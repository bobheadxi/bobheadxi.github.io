---
title: Object Casting with Polymorphic Classes in JavaScript
layout: post
date: 2018-02-01 18:17
image: https://seeklogo.com/images/J/javascript-logo-E967E87D74-seeklogo.com.png
headerImage: true
tag:
- javascript
- nodejs
- bcgsc
category: blog
author: robert
tech_writeup: true
description: saying goodbye to "this.thing = that.thing"
---

Despite my last blog post from way back in 2017, I have not learned any lessons regarding ground beef and continue to eat it on a daily basis. Though I suppose I have changed slightly - I eat more ground pork now, for no real reason other than to make this beauty every day:

<p align="center">
    <img src="https://st2.depositphotos.com/1859627/9435/i/950/depositphotos_94358986-stock-photo-taiwanese-braised-pork-rice.jpg" alt="I do like watermarks and stock photos" width="70%" />
</p>

<p align="center">
    <i>I do like watermarks.</i>
</p>

This particular picture isn't mine but you get the idea.

- TOC
{:toc}

# Prelude
At work, part of my job has been slowly revamping my team's various scattered web platforms - a collection of about 3 servers serving 6 different websites - into a more consolidated and (hopefully) neater codebase.

# The Problem
The previous intern had gotten a bit of a head start on the rewrite by scaffolding a simple server using [Express](https://expressjs.com), a Node.js framework. When I had a look I think I nearly had a heart attack - every endpoint looked something like this:

```js
router.post('/do_thing', (req, res) => {
	var today = new Date();
	
	var method = req.body.method;
	var id = req.body.id;
	var lib = req.body.lib;
	var sublib = req.body.sublib;
	var library_id = req.body.library_id;
	var thingBefore = req.body.thingBefore;
	var otherThingBefore = req.body.otherThingBefore;
	var thingAfter = req.body.thingAfter;
	var otherThingBefore = req.body.otherThingBefore;
	var somethingBefore = req.body.somethingBefore;
	var somethingAfter = req.body.somethingAfter;
	var user = req.body.user;
	var date = utils.formatDate(today);
	var cancelled = req.body.cancelled;
	
	var query = "SET search_path TO " + currDB +"; INSERT INTO adb (thingBefore, somethingbefore, thingAfter, somethingafter, somethingBefore, somethingAfter, username, date, method, fk_lib__id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)";
	var vars = [thingBefore,otherThingBefore,thingAfter,otherThingBefore,somethingBefore,somethingAfter,user, date, method, id];

    // ... more stuff
```

Let's ignore that wild SQL string there for today and look at that big bad list of parameters, most (actually, all) of which boil down to `this.thing = that.thing`. There are several endpoints that take the same parameters as well, where this whole list is copy and pasted.

The fact that these parameter objects are passed into the various queries to do their thing meant that before I started on separating the SQL and database component of the server, I had to work out an effective and standardised way to pass this stuff around - some form of **object casting in JavaScript** (which a reader pointed out should probably have been the title of this post to being with).

# Solution

I could simply use `req.body` which, in theory, should contain everything the server needed, assuming the user has followed the documentation appropriately... until I realized there was no documentation whatsoever. Not to mention that doing this would be making an awful lot of assumptions, and as the saying goes, don't ass*u*me or you will make an *ass* of *u* and *me*! Hehe.

So why not kill two birds with one stone? If each of these sets of parameters was a predefined class, then those classes could effectively act as documentation for our endpoints' input and return types. What I needed was a class that could, given a "definition", cleanly and in one line take an object (such as `req.body` or the return object from a database query) and populate the class's fields. For example:

```js
// My definiton, let's say for the class Lunch:
// {
//    deepfried: something
//    steamed: someotherthing
// }
const lunch = new Lunch( /* object with a bunch of fields */ )
console.log(lunch) // { data: { deepfried: "chicken", steamed: "rice" } }
```

Wow! Wouldn't that be swell. If I could easily have this work for all my classes, that would be great. So I started setting up my extendible class, which would implement the basic shared functions which other classes can then use.

## Part 1: Basic Field Population
Here is the scaffolded class I came up with:

```js
class DataType {
   /**
    * Cast all fields in given object that exists in data onto
    * the given definiton. The given definition must have all fields
    * instantiated to `null`.
    * @param {Object} input Object containing desired data.
    * @param {String} type String representing name of datatype.
    * @param {Object} definition Object containing structure of datatype.
    */
   constructor(
       input,
       type,
       definition
   ) {
       /**
        * The name of this datatype's class.
        * @readonly
        * @member {Object} DataType.data
        */
       this.data = definition;

       /** 
        * The string name of this datatype.
        * @readonly
        * @member {string} DataType.type
        */
       this.type = type;
      
       if (Object.keys(input).length != 0) {
           iterateObjectAndPopulate(input, this.data);
       }
   }
};
```

A child class can then implement `DataType` like this:

```js
class MyType extends DataType {
    constructor(object) {
        // the fields I want this object to have
        const definition = {
            method: null,
            id: null,
            sublib: null,
            // ... the stuff from code block #1
        }
        super(object, 'MyType', definition);
    }
}
```

Now I needed an implementation of the helper function `iterateObjectAndPopulate()`. This function should take two objects - an object with populated fields, and a "definition" object with `null` fields, and populate the definition's fields based on what the input has. This function should also work for nested fields - for example, if I have a very complicated `class Dinner` definition:

```js
{
    appetizer: 'edamame',
    main: {
        deepfried: 'fish',
        steamed: 'dumplings',
    }
}
```

I want to be able to give my class a "flat" object:

```js
{
    appetizer: 'salad',
    deepfried: 'chocolate',
    steamed: 'wontons'
}
```

And have it correctly populate the fields of my definiton. Seemed a bit difficult at first, but it ultimately boils down to a few steps:
- for each key in definition, is:
    - value an object? => recurse on value
    - value `null`? => `this.key = that.key`
- **profit!**

So I came up with this implementation:

```js
/**
* A recursive helper function to populate given 'destination'
* object with matching fields from the given 'source' object.
* @param {Object} source Object containing data.
* @param {Object} destination Object to populate.
*/
function iterateObjectAndPopulate(source, destination) {
   Object.keys(destination).forEach((key) => {
       if (isObject(destination[key])) {
           iterateObjectAndPopulate(source, destination[key]);
           return;
       }
       destination[key] = source[key];
   });
}

function isObject(o) {
    return (typeof o==='object' && o!==null && !(o instanceof Array) && !(o instanceof Date));
}
```

A quick unit test (because what implementation would be complete without one?) to prove that it works, courtesy of [Mocha](https://mochajs.org/) and [chai-expect](https://chaijs.com/api/bdd/) (which I have grown to love):

```js
describe('#constructor()', function () {
    it('should correctly map input to nested keys', function () {
        const input = {
            bisulphite: 'conversion',
            nested: 'chicken',
            genome: 'sequencing'
        };
        const definition = {
            bisulphite: null,
            farm: {
                nested: null,
            },
            genome: null
        };
        const data = new DataType(input, 'sample', definition);
        expect(data.data).to.deep.equal({
            bisulphite: 'conversion',
            farm: {
                nested: 'chicken',
            },
            genome: 'sequencing'             
        });
    });
});
```

Now isn't that beautiful. Not only can I use this for incoming requests, but I can also use this to cleanly populate relevant fields when querying a database (this particular example uses the excellent [pg-promise](https://vitaly-t.github.io/pg-promise/) library):

```js
connection.any(myQuery, args)
    .then((result) => {
        const myData = new MyType(result);
    })
```

## Part 2: Additional Features

Another advantage of this approach is that it allowed me to easily add more features that are inherited by children classes - for example, in code block 1, there is a line which isn't handled by this `DataType` implementation:

```js
var date = utils.formatDate(today);
```

I felt like many of my classes will need to do some sort of modification of their fields, so I figured that the `DataType` constructor could take an additional parameter:

```js
class DataType {
    constructor(
       input,
       type,
       definition,
       format = (data) => {} // offer a default func that does nothing
    ) {
        // ... same as before
        this.format = format
        if (Object.keys(input).length != 0) {
           iterateObjectAndPopulate(input, this.data);
        }
        this.format(this.data)
    }
    // ... etc
```

The child class could then call the `super()` constructor with a function that handles the appropriate formatting:

```js
const format = (data) => {
    data.date = utils.formatDate(data.date);
}
super( /*...params...*/, format);
```

And the given function would then be called by the parent class whenever needed! The reason I do this instead of having the child class handle it themselves in the constructor is because I began to realize our datatypes needed to use different keys when used as return types. For example, `fk_ingredients__name` is not something you want to send to your user - a better key would be `ingredient_name`. The same goes for asking inputs from users - you don't necessarily want your user to send you data with the key `fk_ingredients__name`. Plus, there is probably some security concerns about exposing the inner workings of your database setup, but I'm not very sure if that's actually a concern. Either way, I needed a way to rename keys.

So I gave Mr. `DataType` some new functions:

```js
/**
* Return this object in a more relevant JSON format.
* @returns {Object}
*/
toJSON() {
    return renameKeys(this.data, this.jsonFormat);
}

/**
* Populates this object from an input using its JSON format.
* e.g: `let hist = new types.PendingLibraryHistory({}).fromJSON(jsonInput);`
* @param {Object} input Object containing desired JSON-formatted data.
* @returns {DataType} self
*/
fromJSON(input) {
    const reversedFormat = swapKeyValues(this.jsonFormat);
    input = renameKeys(input, reversedFormat);
    iterateObjectAndPopulate(input, this.data);
    this.format(this.data); // Aha! Passing this function as a
                            // parameter came in handy, I can
			    // now call it wherever I want
    return this;
}
```

Some quick explanations:
- `this.jsonFormat` is set from yet another parameter in `super()`, and it is a dictionary of "translations":
```js
const jsonFormat = {
    myOriginalKeyName: 'myNewKeyName'
}
```
- `toJSON()` just needs convert the keys, nothing fancy to be done
- for `fromJSON()` to take an object using the `jsonFormat` keys, the function needs to first reverse the `jsonFormat`, rename the keys of the input using the reversed format (essentially translating it back to its original form), then populate and format the class' data
- I return `this` in `fromJSON()` to allow the function to be chained during construction:

```js
const data = new MyType({}).fromJSON(req.body);
```

So how to go about renaming and swapping keys? Since the implementations are fairly straight forward and is conceptually similar to `iterateAndPopulateObject()`, I'll just include them here:

```js
/**
* Helper function that returns a new object with the keys of target
* object renamed using given key mappings.
* Useful for JSON formatting.
* @param {Object} target Object to modify
* @param {Object} newKeys Key mappings (e.g. {oldKey: 'NewKey!'})
* @returns {Object}
*/
function renameKeys(target, newKeys) {
    const keyValues = Object.keys(target).map((key) => {
        const newKey = newKeys[key] || key;
        if (isObject(target[key])) {
            // Needs to work for nested keys, so recurse on
            // fields that are objects
            return { [newKey] : renameKeys(target[key], newKeys) };
        }
        return { [newKey]: target[key] };
    });
    return Object.assign({}, ...keyValues);
}

/**
* Helper function that returns a new object with the keys and values of
* given object swapped.
* Useful for JSON de-formatting.
* @param {Object} object Object whose keys to swap
* @returns {Object}
*/
function swapKeyValues(object) {
    const keyValues = Object.keys(object).map((key) => {
        return { [object[key]]: key };
    });
    return Object.assign({}, ...keyValues);
};
```

**Update**: A reader asked about a line in these helpers that I think is pretty cool:
```js
return { [newKey]: target[key] };
```
This allows you to use a string variable, `newKey`, as the name of a key when instantiating a dictionary:
```js
const key = 'chicken';
const object = { [key]: 'wing' };
expect(object).to.deep.equal({
    chicken: 'wing'
})
```
Nifty!

Of course, I also wrote unit tests to make sure `toJSON()` and `fromJSON()` worked as intended.

The nice thing about this approach - any any approach using polymorphic classes, really - is its crazy flexibility, which I took for granted for a very long time. Here is an example of a class that takes an extra constructor parameter to allow more specific customization of its `data`:

```js
/**
 * Represents a data point in a chart.
 * @extends DataType
 */
exports.Point = class extends DataType {
    /**
     * Casts given object into a chart Point.
     * @param {Object} object Data for point
     * @param {number} [decimals] Decimal points to fix to (default: 2)
     */
    constructor(object, decimals = 2) {
        const definition = {
            key: null,
            val: null,
        };
        const formatFunction = (data) => {
            data.key = data.key.toFixed(decimals);
            if (typeof data.val === 'string') data.val = parseInt(data.val);
        };
        const jsonFormat = {
            key: 'x',
            val: 'y',
        };
        super(object, 'Point', definition, jsonFormat, formatFunction);
    }
};
```

And another example that has an extra parameter as well as extra class function to modify the class's `data`:

```js
/**
 * Represents a detailed library.
 * @extends DataType
 */
exports.Library = class extends DataType {
    /**
     * Casts given object into a Library.
     * @param {Object} object
     * @param {boolean} [metric] Whether to include metric data or not.
     */
    constructor(object, metric = true) {
        const definition = {
            // ...
        };
        if (metric) {
            definition.metric = {
                // ...
            };
        }
        super(object, 'Library', definition);
    }

    /**
     * Attach process information to this library.
     * @param {Object[]} processes 
     */
    addProcesses(processes) {
        this.data.process = { };
        for (const p of processes) {
            this.data.process[p.name] = {
                description: p.description,
                date: p.datetime
            };
        }
    };
};
```

And if you ever feel like adding functionality across all classes, you can simply implement it in the base `DataType` class. Possibilities everywhere!

Feel free to get in touch through my email if you have any questions or suggestions about this though! I personally have found this very handy and although I'm sure it could use some changes to improve its flexibility (one thing I'm hoping to look into is implementing some sort of field validations, such as checking if required fields are present) I think this is far better than the original sprawling list of `this.thing = that.thing`.

Thanks for reading, and I hope you found this useful!
