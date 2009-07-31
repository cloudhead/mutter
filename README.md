mutter
======

    $ my words come out, 
        in color and
            style

> mutter is the tiny CLI library, with a focus on style.
> use it in your apps to have _gorgeous_ command-line output!

usage (command-line output)
---------------------------

    require 'mutter'

    mut = Mutter.new
    mut.say "hello _world_"         # underlines 'world'
    mut.say "hello world",   :bold  # bolds the whole string
    mut.say "hello [world]", :cyan  # inverts 'world', and colors the string cyan
    mut.print "bonjour!"            # alias of `say`
    mut["hola"]                     # yet another way to print

styles
------
mutter supports these styles:

    :bold, :underline, :inverse

and these colors:

    :red, :green, :blue, :yellow, :cyan, :purple, :white, :black

customization
-------------

    styles = {
      :warning => {                     # an alias you can use anywhere in mutter
        :match => ['*!', '!*'],         # will match *!mutter!*
        :style => ['yellow', 'bold']    # these styles will be applied to the match
      },
      :error => {
        :match => '!!',                 # will match !!mutter!!
        :style => ['red', 'underline']
      }
    }
    
    mut = Mutter.new(styles)
    mut.say     "warning, warning!", :warning
    mut.warning "warning, warning!"
    mut.say     "gosh, we have an !!error!!"
    
### quick styles

    mut = Mutter.new :yellow => '~'
    mut.say "~[black on yellow!]~"

### YAML styles

mutter can also read styles from _YAML_ files, just give it the path, like so:

    Mutter.new("styles.yml")

There's an example style in `spec/`

installation
------------

    $ sudo gem install cloudhead-mutter
    
That's it!
----------

_have fun_

Footnote
--------

This code is _highly experimental_, don't try this at home!
