---
layout: post
title: Extracting RSS from webpages
draft: true
---

RSS feeds are standards for internet post syndication. It allows you to be updated when a
blog or podcast you have subscribed to publishes new content. 
Many modern websites do not support rss feeds. 
Mailing lists are sometimes an alternative, but it can be undesirable to give your email out to strangers.

There are online services that do the job of turning web pages into rss feeds, but many will cost money or have strict limits.
When these services stop working, the only recourse is to search the web for a replacement.
You then have the hassle of porting all of your subscriptions over.

To solve this issue I have created a simple program in common lisp that, by defining two small functions, one can extract
the relevant features from a webpage and get an xml feed out of it. 
There is also a small script that will update these feeds and push the results to an external git repository.
By running this as a cron job (say on a constantly running single board computer), 
or through a CI pipeline (such as github actions), one can have their own rss feed generator. 
One can then point their rss reader to these public git repositories to subscribe to the rss feeds

<!-- more -->


