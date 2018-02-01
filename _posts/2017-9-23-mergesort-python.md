---
title: "Python and Mergesorts"
layout: post
date: 2017-09-23 22:44
image: 
headerImage: false
tag:
- python
- algorithm
star: false
category: blog
author: robert
description: I don't know what I am doing.
---

Two weeks into my second year of university, I have learned a very important lesson:

Ground beef is not something I want to eat every day.

Not too long ago, eggs and ground beef was the holy *binity* (is that a word?) of my daily diet, but after half a summer of ground beef in fried rice, pasta sauce, messy pseudo-burgers and every stirfry imaginable, I have decided that the dollars saved on dirt-cheap ground beef is not worth the sanity loss.

# Prelude

Towards the end of summer, with nothing to distract me from pickle sales except a few personal projects, I decided to start a [Coursera course in algorithms](https://www.coursera.org/learn/algorithms-part1/home/info).

It was fantastic, very confusing, and definitely made me feel very cool. I got up to Week 3 before school started. Unfortunately, I have come to accept that I probably won't get the chance to finish the course any time soon.

The lectures use Java as an expository language. Having spent a lot of time with Java already, I think I am long overdue for some Python experience - especially because I have a big club project coming up that will use a lot of Python. So here goes a very brief walkthrough of what I've learnt about mergesorts, explained in Python. 

I'll be implementing a **basic mergesort** and demonstrating a nifty alternative to it: the **bottom-up mergesort**.

Hopefully, this might be useful to someone one day, and my existence will have some purpose. If you are interested in learning this content properly I highly recommend the Coursera course.

# Part 1: The Basic Mergesort

When sorting a list, the basic idea behind a mergesort goes as follows:

1. Divide the items in half
2. Recursively sort each half
3. Merge the sorted halves
4. Tada! Feast on your your sorted list/array/whatever.

This is fairly straight-forward to implement. To start off, I need something that can merge two sorted halves of a list, to solve Step 3.

### Merging sorted halves

Python arrays aren't like Java's fixed-length arrays - from what I have read, they are variable-length arrays, which means that I could pass each half as a separate list (`left` and `right`) and `append()` elements in order onto a `result`. This would alleviate the need for a copy of the list in `temp`. It also means that, at the expense of some extra memory usage, the algorithm will be able to complete a merge with less data movement and should be faster overall.

For this post, I will go with Method 2, but I will include an implementation of Method 1 at the end. Using Method 2, the core of my `merge` will be a loop that iterates two position-tracking integers:

-  `x` over `left`  
-  `y` over `right`

This allows the algorithm to compare the elements of each half to one another to sort them.

```python
elif right[y] < left[x]:
	result.append(right[y])
	y+=1
else:
	result.append(left[x])
	x+=1
```

This works, but can be optimized a bit - if we reach the end of the first half, we know that the remaining items in the second half are all larger, so we can just add the next value straight away (and vice versa).

The complete implementation actually took me a while to get right because I'm bad at Python, but the resulting `merge()` looks like this:

```python
def merge(left, right):
	result = []
	x, y = 0, 0
	for z in range(0, len(left) + len(right)):
		if x == len(left): # if at the end of 1st half,
			result.append(right[y]) # add all values of 2nd half
			y+=1
		elif y == len(right): # if at the end of 2nd half,
			result.append(left[x]) # add all values of 1st half
			x+=1
		elif right[y] < left[x]:
			result.append(right[y])
			y+=1
		else:
			result.append(left[x])
			x+=1
	return result
```

And a quick test to verify it works:

```python
left = [5,6,7,8]
right = [1,2,3,4]
print(merge(left,right)) # output = [1, 2, 3, 4, 5, 6, 7, 8]
```

Yay!

### Sorting

Using only `merge()`, we can sort an entire list simply by recursively dividing the list into smaller and smaller halves until they can no longer be divided. It is most easily visualized as a tree, where each branch is a smaller and smaller part of the original list.

To do this we need a function, `sort()`, that calculates a `mid` and calls itself on `list[:mid]` (the first half) and `list[mid:]`(the second half). By using `merge()` on the halves, you eventually end up with a sorted list.

```python
def mergesort(list):
	if len(list) < 2: # stop recursion when 
		return list	 # sublists are size 1 or 0
	mid = int (len(list)/2) # calculate midpoint
	left = mergesort(list[:mid]) # recursive sort 1st half
	right = mergesort(list[mid:]) # recursive sort 2nd half
	return merge(left, right) # merge the two halves
```

Running a similar test from before verifies that this works:

```python
list = [2,5,1,8,3,8,0]
print(mergesort(list)) # output = [0, 1, 2, 3, 5, 8, 8]
```



# Part 2: The Bottom-Up Mergesort

Recusion adds overhead that can become important once the input size is very large.

The bottom-up mergesort solves this by doing the opposite of the standard mergesort: instead of starting with the entire list and recursively breaking it down, it starts with sublists of size 1 and merges them in pairs until the entire list is sorted.

The process is as follows:
1. Break the list into sublists of size 2, and merge the two halves of each sublist. This the halves are of size 1, this completely sorts each sublist.
2. Break the list into sublists twice as large,  where each half has been sorted by Step 1. This means each sublist can be merged and sorted.
3. Repeat step 2 until the sublist is the size of the entire list, by which point the entire list has been sorted.

The implementation, using the same `merge()` from part one:

```python
def bottomup_mergesort(list):
	length = len(list)
	size = 1
	while size < length:
		size+=size # initializes at 2 as described
		for pos in range(0, length, size):
			sublist_start = pos
			sublist_mid   = pos + (size / 2)
			sublist_end = pos + size
			left  = list[ sublist_start : sublist_mid ]
			right = list[   sublist_mid : sublist_end ]
			list[sublist_start:sublist_end] = merge(left, right)
	return list
```

And a test to verify it works:

```python
randlist = []
for x in range (0, 100001):
	randlist.append(random.randint(0, 100))
list = bottomup_mergesort(randlist)
if sorted(l) == l:
	print("Is sorted!") # prints!
```



# Part 3: In-Place Mergesort

The premise behind the in-place mergesort is that by using an auxillary array, `temp`, and operating on the original `list`, the algorithm will not need to take up extra memory by passing around subarrays.

I won't go too much into the details, but here are my implementations of both a normal mergesort and a bottom-up mergesort, based on the algorithm implemented in the Coursera course:

```python
def merge(list, temp, low, mid, high):
	'''
	Merges two sorted halves of a list in order.
	'''
	for z in range(low, high+1):
		temp[z] = list[z] # copy items into temp
	
	first = low  # position in 1st half
	sec   = mid + 1	 # position in 2nd half
	
	for z in range(low, high+1):
		if first > mid: # if past the end of 1st half,
			list[z] = temp[sec]	# add next value of 2nd half
			sec+=1

		elif sec > high: # if past the end of 2nd half,
			list[z] = temp[first] # add value from 1st half,
			first+=1

		elif temp[sec] < temp[first]: # if value in 2nd < value in 1st,
			list[z] = temp[sec] # add value from 2nd half,
			sec+=1
		
		else: # if value in 1st < value in 2nd,
			list[z] = temp[first] # add next value in 1st half,
			first+=1 # imcrement first

def sort(list, temp, low, high):
	if high <= low:
		return # stop recursion
	mid = low + (high - low) / 2 # calculate mid between high and low
	sort(list, temp, low, mid) # recursive sort the first half
	sort(list, temp, mid+1, high) # recursive sort the second half
	merge(list, temp, low, mid, high) # merge the two halves
	
def mergesort(list):
	length = len(list)
	temp = [0] * length
	sort(list, temp, 0, length-1)
	
def bottomup_mergesort(list):
	length = len(list)
	temp = [0] * length
	size = 1
	while size < length:
		pos = 0
		while pos < length:
			if (pos+2*size-1 >= length):
				merge(list, temp, pos, pos+size-1, length-1)
			else:
				merge(list, temp, pos, pos+size-1, pos+2*size-1)
			pos+=2*size
		size+=size
	return
```

# Part 4: Complexity Analysis

I will get back to this, pretty tired now. Cheers!

