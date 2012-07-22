---
layout: default
title: Hatchet
---

# About Hatchet

## Why?

Logging is important and as systems become more distributed and eventual through
the use of queues and services it just becomes more important. I, [Garry Shutler](http://twitter.com/gshutler),
searched for a logger that provided the functionality I was familiar with from
[log4j](http://logging.apache.org/log4j/):

 * Logging to multiple locations (files, services, email) from a single call
 * Configuring logging levels on a per-namespace/class level

And the additions given by [slf4j](http://www.slf4j.org/):

 * A common interface that lets library clients decide on how messages are
   logged

However, I wanted it to be in style that felt like Ruby.

The nearest I found was [log4r](http://log4r.rubyforge.org/) but it felt too
much like Java-in-Ruby so I set out to scratch my own itch by creating Hatchet.

## Goals

The primary goal of Hatchet is to be easy to use. Both from the perspective of
[developers using it to log messages](/hatchet/#usage) and from the perspective
of people wanting to extend Hatchet by [creating their own appenders](/hatchet/extending/appenders.html)
or [creating their own formatters](/hatchet/extending/formatters.html). The
secondary goal is to provide all of the functionality previously mentioned.

I know I have achieved these goals for myself as my own itch is well and truly
scratched. Hopefully, the rest of the Ruby community will get some benefit from
Hatchet too.

