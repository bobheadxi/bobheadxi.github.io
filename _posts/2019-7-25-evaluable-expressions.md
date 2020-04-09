---
title: "Evaluable Expressions in Configuration"
layout: post
date: 2019-7-25
image: https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/1200px-Go_Logo_Blue.svg.png
headerImage: true
tag:
- design
- golang
- configuration
- riot-games
tech_writeup: true
category: blog
author: robert
description: metaconfiguration with Go!
---

One of my projects at [Riot Games](/riot-games/) (as I introduced in a blog post
on the official Riot Games technology blog, ["Technology Interns at Riot Games"](https://technology.riotgames.com/news/technology-interns-riot-games))
involved designing an extension to an internal application specification we have to
describe services to allow engineers to declaratively define alerts on their
application. The goal of the specification is to be human-readable for operators
in different regions while giving programs sufficient information to automate
the deployment of services and everything they require. Deployment at Riot Games
is covered in
[this blog post ("Dynamic Applications: Micro-Service Ecosystem")](https://technology.riotgames.com/news/running-online-services-riot-part-iv),
and our application specification is mentioned in
[this AWS Skill Point Episode ("Riot Games and League of Legends")](https://www.twitch.tv/videos/458272506?t=49m43s)
if you want to learn more!

---

**✅ Update(2/25/2020)**: a [new post ("Products, Not Services")](https://technology.riotgames.com/news/running-online-services-riot-part-vi)
was recently published that elaborates on the specification I worked on, and briefly mentions my
intern project! (emphasis mine)

> The specification also includes all the metadata required to run and operate an entire environment.
> A growing set including configuration, secrets, metrics, **alerts**, documentation, deployment and
> rollout strategies, inbound network restrictions, as well as storage, database, and caching requirements.

---

<p align="center">
    <img  width="70%" src="https://technology.riotgames.com/sites/default/files/intern10-robert1.png" />
</p>

<p align="center">
    <i style="font-size:90%;">
    Rough diagram I made of what this stuff is supposed to do, as outlined in
    <a href="https://technology.riotgames.com/news/technology-interns-riot-games">this blog post on the official Riot Games Technology blog</a>.
    </i>
</p>

So an idea I had as part of my extension design proposal was to allow users to
specify "selections" from other parts of the spec and perform arithmetic on them
as values in their alert thresholds. This would allow engineers to set a single
alert that would alert if 75% of their packs die, for example, without having to
use a hardcoded number and overriding thresholds in each instance or environment
that uses a different pack configuration. The spec would look something like:

```yaml
value: SELECT(container.count) - 1
```

Values could also be selected out of configuration with this syntax:

```yaml
value: SELECT(configuration[name='my-config-key'].value)
```

Selections would be evaluated at deploy-time on a fully collapsed application
spec, and the deploy diff reflected to the user would show the evaluated value
for validation.

(Aside: none of the examples in the post are what the specification actually
looks like, but the ideas are roughly the same)

The response to this feature was pretty positive, and it quickly found several
useful use cases that helped simplify and clarify alert definitions in the context
of an application for human readers. For example, in an alert on something like:

```yaml
metric: queue.size
threshold:
- type: max
  value: SELECT(configuration[name='my_queue.max_queue_size'].value) * 0.75
```

The meaning of the alert becomes immediately pretty clear, and service configuration
a lot easier, with alerts automatically scaling off of a configured property. It
also meant that a separate percentage metric on the queue size doesn't need to
be created and tracked to get this same feature without selection.

## Implementation

For this post I'll just give a high-level overview of the implementation details. 
he core of the feature is in a Go string type I called `EvaluableExpression`
that exposed the ability to evaluate the string on a collapsed application:

```go
type EvaluableExpression string

// EvaluateInt ensures the expression outputs an integer and returns it. Leaves
// room for future implementations like EvaluateBool, EvaluateFloat, etc.
func (e EvaluableExpression) EvaluateInt(app *Application) (int, error) {
  val, err := e.evaluate(app)
  /* check for errors, validity of value (numerical, no infinities, etc) */
  return intVal, nil
}

// evaluate outputs the raw value of an evaluation for use by implementations
// of EvaluableExpression::EvaluateXXX()
func (e EvaluableExpression) evaluate(app *Application) (interface{}, error) {
  /* magic */
}
```

I tried two approaches to this. Both leveraged an awesome JSON selector library,
[`github.com/thedevsaddam/gojsonq`](https://github.com/thedevsaddam/gojsonq),
and [`github.com/Knetic/govaluate`](https://github.com/Knetic/govaluate) (also
awesome) for expression evaluation. Most of my work involved in making them
interoperate by evaluating selectors first, and then performing the necessary
arithmetic.

### Approach 1: Go AST Parser

The first approach used three passes:

1. use the Golang [abstract syntax tree parser](https://golang.org/pkg/go/ast/)
  to identify "selectors", such as `my.value` (this approach did not have the
  `SELECT` syntax described early - an example of the initial proposal's syntax
  was simply `container.count - 1`. In this case, `container.count` is a valid Go selector
  that would be recognized by the AST parser)
2. evalaute the selectors using the `gojsonq` library
3. perform expression arithmetic using the `govaluate` library with the selected
  values as [parameters to the expression](https://github.com/Knetic/govaluate#how-do-i-use-it)

As sexy as this method was didn't actually end up using this approach - I ran
into serious issues when it came to selecting things out of arrays of objects. 
Because applications are collapsed in various ways, there is no guarantee of
the stability of array properties, so allowing selection by index using standard
Go syntax (ie `myfield[10].value`) was a no-go. Wrapping that in some custom
syntax magic (like the `myfield[key=value].value` semantic in the final design)
was also problematic, since for the Go parser to recognize this the index value
would have to be wrapped as a string (`["key=value"]`), and feedback for this
workaround was that it seemed confusing. It could have "escaped" it as a string,
but it would have meant adding yet another pass over the expression that made the
whole thing kind of convoluted. Configurations fields with dashes in them
(`my-field`) was also problematic since the Go parser would recognize it as
arithmetic.

So since I didn't end up using the parser, I put it up as a
[gist](https://gist.github.com/bobheadxi/65a6fc4c77e5b339c48a370f70b11907)!
I still think it's kind of neat, even if it's not very practical. The implementation
walks an expression like this:

```
ast.ExprStmt from `parser.ParseExpr("my.deep.selector - 3")`
 └── X: *ast.BinaryExpr (Op: `-`)
     ├── X: *ast.SelectorExpr
     |   ├── X: *ast.SelectorExpr
     |   |   ├── X: *ast.Ident (Name: 'my')
     |   |   └── Sel: *ast.Ident (Name: 'deep')
     |   └── Sel: *ast.Ident (Name: 'selector')
     └── Y: *ast.BasicLit (Kind: INT)
```

The visitor would walk the syntax tree, collecting parts of the select expression
from any `SelectorExpr` it encounters and return fully reconstructed selectors
in a slice. A good chunk of the work is done by [`ast.Walk`](https://golang.org/pkg/go/ast/#Walk),
which I leveraged by simply implementing the [`ast.Visitor` interface](https://golang.org/pkg/go/ast/#Visitor).

It was kind of cool finding out that Go offered its AST parser as a library, and
it was fun putting the stuff I learned about syntax trees while working on
[*Durian*](https://github.com/ubclaunchpad/durian) to semi-useful use... but in
the end Approach 2 was *much* more practical.

### Approach 2: Pseudo-function

This approach leveraged [`govaluate` functions](https://github.com/Knetic/govaluate#functions),
which is the reason for the `SELECT` syntax (which serves as the "function") in
the final design. It consists of just 2 passes, and is far simpler than my first
approach:

1. "escape" everything within the argument for a `SELECT` call as a string
  (ie `SELECT(my.key)` becomes `SELECT("my.key")`) by looking for indices of
  `SELECT` in the expression and using [balanced brackets](https://www.hackerrank.com/challenges/balanced-brackets/problem)
  to encapsulate the entire argument
2. define a function on the expression evaluation that would take the argument
  as a single selector and evaluate it:

```go
expression, _ := govaluate.NewEvaluableExpressionWithFunctions(evaluable, 
  map[string]govaluate.ExpressionFunction{
    "SELECT": func(args ...interface{}) (interface{}, error) {
      /* interpret args as single selector string (the 'key') */
      return getFromJSONQ(document, key)
    },
  })
return expression.Evaluate(nil)
```

Things get a little hairy in the `getFromJSONQ` function, however: this function
would have to handle the special array selection syntax that matches on specified
keys (ie `SELECT(array[key=value])`). It involved some finicking to parse out
the key and target value, and some hacks to get the appropriate subdocument from
the `gojsonq` library's documents, which I shall leave as an exercise for the
reader :wink: But with that out of the way, this implementation kind of... just
worked. Woo!

## Asides

There were still complications about when in the deploy pipeline this evaluation
should occur, and how specifications should be stored (evaluated? unevaluated?),
and so on, but yeah, this post covers the gist of the idea.

As a follow-up, since I wrote this post during my internship but held off on publishing until
[the official post](https://technology.riotgames.com/news/technology-interns-riot-games) was
released - since then I've discovered [`antonmedv/expr`](https://github.com/antonmedv/expr),
which seems to cover a similar problem space.
