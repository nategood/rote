Intro
-----

**This project is only in its *very* early stages and will likely be changing quite a bit.**

Rote is a RESTful note-taking application.  The syntax is intended to feel natural but also provide a clean interface for adding meta data about your notes.

Rote uses [Sintra](http://sinatrarb.com) for its clean, RESTful API and [Mongo](http://mongodb.org) to store notes.

Installation
------------

Requires MongoDB to be installed and running.  Still need to get config out of the Task class and into a yaml config file.

Use bundler to install dependancies.  From the repo's root directory run...

    > bundle install

Run it
------

To get a basic version of the Sinatra app running, from the repo's root directory run...

    > ruby -rubygems ctlr.rb

TODO Add rackup support

Example
-------

The syntax for adding tasks is very clean.  Here is an example curl request to add a new task to remind us to pick up the laundry tomorrow

    curl -X POST -d "Pick up the #laundry!!" http://example.com/tomorrow

We'll start by looking at the task itself.  The message we `POST` is simple plain text.  The `#` indicates the presence of a tag.  This tag word is indexed and can be used in the future to categorize and locate notes quickly.  Finally, all notes can be followed up with a series of `!`s.  The `!` indicates priority or how important the item is.  The more `!`, the more important.  This can be used to prioritize notes/tasks

Now lets fetch all the tasks for tomorrow

    curl http://example.com/tomorrow

Or we can see all future tasks

    curl http://example.com/future

Or tasks for a certain day

    curl 

General Syntax for Notes

    "Some text that can include some #tags within it optionally followed by exclamation points that indicate the priority of this item!!!"

General Syntax for URL

    http://example.com/time-frame

Future
------

 - Will be adding documentation for the various URL endpoints and how the can be used to 
 - Adding ability to flag notes/tasks as complete
 - A simple web interface for managing in browser as opposed to the command line