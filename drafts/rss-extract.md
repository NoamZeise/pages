---
layout: post
title: Extracting RSS from webpages
draft: true
---

A program in common lisp that, by defining two small functions, 
one can extract the relevant features from a webpage and 
get an RSS feed out of it. 
There is also a script that will update the feeds and push them to
an external git repository.

By running this as a cron job (say on a constantly running single board computer), 
or through a CI pipeline (such as github actions), one can have their own 
RSS feeds accesible from anywhere with an internet connection.
One can then point their rss reader to these public git repositories to subscribe to the rss feeds

This project uses:
* [dexador](https://github.com/fukamachi/dexador) - http client
* [plump](https://github.com/Shinmera/plump) - DOM parsing
* [cl-ppcre](http://edicl.github.io/cl-ppcre/) - regex

<!-- more -->

## Rationale

RSS feeds are standard for internet post syndication. 
It allows you to be updated when a blog or podcast you have subscribed to publishes new content. 
Some modern websites do not support rss feeds. 
Mailing lists can be an alternative, but it is undesirable to give your email out to strangers.

There are online services that do the job of turning web pages into rss feeds, but will cost money or have strict limits.
When these services stop working, the only recourse is to search the web for a replacement.
You then have the hassle of porting all of your subscriptions over. 
With this tool you have complete control over your feeds and can host them hovever you like.


## Walkthrough

I will go through implementing a feed for an example website. 
Here I am choosing the lexaloffe bulletin board, and will created a feed 
showing cartridges for the newly public picotron fantasy computer. 
Here's the link to the webpage:

[https://www.lexaloffle.com/bbs/?cat=8#sub=2](https://www.lexaloffle.com/bbs/?cat=8#sub=2)


Unlike the pico-8, the picotron does not yet have a way to search for cartridges from 
within the program.

First we inspect the html and see how we might isolate each post entry individually.
By searching for key terms we see on each post, we see that data for posts are within a script.

```javascript
pdat=[

	['144632', 141137, 
	`Contra 3 The Alien Wars intro`,
	"/bbs/thumbs/pico64_contra3-0.png",96,64,
	"2024-03-27 05:57:51" ,52360, "Turbochop",
	"2024-03-27 12:35:35" ,52360, "Turbochop"
	,1,3,0,8,2,'0',[],0,21,,``,``],
    
	['142940', 140647, 
	`PICOTRON 0.1 Release Bug Thread!`,
	"https://www.lexaloffle.com"
	"/bbs/files/32135/ck.jpg",96,48,
	"2024-03-14 20:06:50" 32135, "thattomhall",
	"2024-03-27 12:26:26",27691, "pancelor"
	,39,276,0,8,6,'0',
	["picotron","bugs",],0,16,,``,``],
	
	// ...
```

Note that the webpage gives us non-cartridge results too. 
The javascript will filter out the relevant category based on the url `#sub=2`.
By going through the code we find that the position 16 in the array holds the category.

```javascript
// ...
else if (dat[16] == 2) label += 'Cartridges';
else if (dat[16] == 3) label += 'Work in Progress';
else if (dat[16] == 4) label += 'Collaboration';
// ...			
```

So we need to take each element of the array and ignore any posts 
that aren't in the release category.

We create a parser by defining a method for extracting article nodes, 
this does not have to be an html node, it can be anything. 
What is extracted is then passed to the second function one must define,
which fills out the details of the article from the information extracted
by the first function.

Now we write these functions. Open sly or slime and load the `extract-rss.asd` file,
then do `(ql:quickload :extract-rss)` to load the library. 
This makes it easy to test functions and try and extract the relevant info about a post.

First node that the script with the info has an id `cart_data_script`. 
This means we can get the script node we need into a variable. 
`extract-rss` includes the [plump](https://github.com/Shinmera/plump) 
library for traversing the dom. Using that with some regex and string manipulation
we can write a function that returns an array of article data with the following.

```lisp
(defun get-picotron-cart-posts (url)     
  (let*
     ;; get script holding post data
     ((script
	  (plump:get-element-by-id 
	   (extract-rss:get-page-root
	    "https://www.lexaloffle.com/bbs/?cat=8#sub=2") 
	   "cart_data_script")) ;; id in dom
	;; get post array from script text
	 (array-text (cl-ppcre:scan-to-strings 
		      "pdat=\\[[^;]*"
		      (plump:text *script-node*))))
  ;; split the array by newlines and select only
  ;; ones that have a category 2 (ie cartridge)
    (loop for s in 
	  (uiop:split-string
	   *post-data* 
	   :separator uiop:+lf+) ; split newlines
	  when (cl-ppcre:scan ",2,'" s) 
	  collect s)))
```
