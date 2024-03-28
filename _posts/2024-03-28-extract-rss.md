---
layout: post
title: Extracting RSS from webpages
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

We make a new webpage instance to represent this new xml feed and fill it in with the
details of the feed. For now the two functions we need are blank.

```lisp
(defparameter
 *picotron-carts*
 (make-instance
  'extract-rss:webpage
  :title "Picotron Cartridges"
  :url "https://www.lexaloffle.com/bbs/?cat=8#sub=2"
  :xml-file "picotron-carts"
  :extract-article-nodes
  (lambda (node) ()) ; dummy function
  :make-article
  (lambda (data) ()))) ; dummy function
```

First node that the script with the info has an id `cart_data_script`. 
This means we can get the script node we need into a variable. 
`extract-rss` includes the [plump](https://github.com/Shinmera/plump) 
library for traversing the dom. 

To figure out how to parse the page to get what we want here are some
helpful functions.

```lisp
;; We can get the webpage root with
(defparameter *root* 
  (extract-rss:get-page-root 
    "https://www.lexaloffle.com/bbs/?cat=8#sub=2"

;; the text for the script containing cart data
(defparameter *script-data*
  (plump:text
    (plump:get-element-by-id root-node "cart_data_script")))
```

Using that with some regex and string manipulation
we can write a function that returns an array of article data. 
we replace the first dummy function with this.

```lisp
:extract-article-nodes
(lambda (root-node)
  (let* ((script-node
	  (plump:get-element-by-id root-node "cart_data_script"))
	 (raw-text
	  (if script-node (plump:text script-node) ""))
	 (start-array (cl-ppcre:scan "pdat=\\[" raw-text))
	 (end-array (nth-value 1 (cl-ppcre:scan "\\];" raw-text)))
	 (array-text (subseq raw-text start-array end-array)))
    (loop for s in 
	  (uiop:split-string
	   array-text
	   :separator uiop:+lf+)
	  when (cl-ppcre:scan ",2,'" s)
	  collect s)))
```

We can then use this function to help figure out how to write the next one

```lisp
;; get a list of the extracted article data
;; from the function we just defined
(extract-rss:get-article-nodes *picotron-carts*)
```

To parse I first wrote a function to take the input of an array and parse out the
individual elements and return it. I won't print it here as it is long and simple.
After that we can write the function we need to create an article given the text we 
extracted for each article.

```lisp 
:make-article
(lambda (text)
  (let ((article
	 (make-instance 'extract-rss:article))
	(data
	 ;; parse string into array
	 ;; of strings for each element
	 ;; in javascript array string
	 (get-picotron-article-data text)))
    (loop
     for e in data and i from 0 do
     ;; clean up string
     (let ((dat (string-trim " '\"`" e)))
       ;; get attribs we store in article class
       (cond
	((= i 1)
	 (setf
	  (extract-rss::link article)
	  (format
	   nil
	   "https://www.lexaloffe.com/bbs/?tid=~a"
	   dat)))
	((= i 2)
	 (setf (extract-rss::title article) dat))
	((= i 3)
	 (setf
	  (extract-rss::image article)
	  (format
	   nil
	   "https://www.lexaloffe.com~a"
	   dat)))
	((= i 8)
	 (setf (extract-rss::author article) dat))
	((= i 9)
	 (setf (extract-rss::date article) dat))
	((= i 18)
	 (setf (extract-rss::category article) dat)))))
    article))
```

And with that we can generate an rss feed xml file in the current directory with

```lisp
(extract-rss:extract-rss *picotron-carts*)
```
