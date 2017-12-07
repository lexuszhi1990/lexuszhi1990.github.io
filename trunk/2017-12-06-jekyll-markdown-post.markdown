---
layout: post
title: jekyll markdown post
date: 2017-12-06 13:46
categories: [dev]
published: true
---

This is a demo of all styled elements in Jekyll Now.

-----

### headers

Headers are heavily influenced by GitHub's markdown style.

# Header 1 #

## Header 2 ##

### Header 3 ###

#### Header 4 ####

----

### links

A link to [Jekyll Now](http://github.com/barryclark/jekyll-now/). A big ass literal link <http://github.com/barryclark/jekyll-now/>

An image, located within /images

![an image alt text]({{ site.baseurl }}/images/jekyll-logo.png "an image title")

---

### lists

* A bulletted list
- alternative syntax 1
+ alternative syntax 2
  - an indented list item

1. An
2. ordered
3. list

Inline markup styles:

- _italics_
- **bold**
- `code()`

----

### quote

> Blockquote
>> Nested Blockquote

----

### hightlights

Syntax highlighting can be used by wrapping your code in a liquid tag like so:

{% highlight javascript %}
/* Some pointless Javascript */
var rawr = ["r", "a", "w", "r"];
{% endhighlight %}

Use two trailing spaces
on the right
to create linebreak tags

----

### tables ###

First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column

### horizontal lines

----
****
