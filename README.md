mutter
======

    $ my words come out, 
        in color and
            style

> mutter is the tiny CLI library, with a focus on style—
> taking the concepts of _separation of style & content_ to the command-line!

usage (command-line output)
---------------------------

    require 'mutter'

    mut = Mutter.new
    mut.say "hello _world_"         # underlines 'world'
    mut.say "hello world",   :bold  # bolds the whole string
    mut.say "hello [world]", :cyan  # inverts 'world', and colors the string cyan
    mut.print "bonjour!"            # alias of `say`
    mut["_hola_"]                   # return the stylized string without printing

styles
------
mutter supports these styles:

    :bold, :underline, :inverse, :blink

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
    mut.say     "warning, the dogs have escaped!", :warning  # These two are
    mut.warning "warning, the dogs have escaped!"            # equivalent
    mut.say     "gosh, we have an !!error!!"

### YAML
    
The previous example could have (and should really have) been written in a separate .yml file, like so:
    
    warning:
      match: 
        - '*!'
        - '!*
      style:
        - yellow
        - bold

    error:
      match: '!!'
      style:
        - red
        - underline

and then loaded like this:

    Mutter.new("styles.yml")
    
### quick styles

    mut = Mutter.new :yellow => '~'
    mut.say "~[black on yellow!]~"
    
### add/remove styles from an instance

    mut = Mutter.new(:blink)
    mut >> :blink               # remove :blink
    mut << :bold << :underline  # add :bold and :underline
    mut.say "hello mutter."     # bold and underlined

installation
------------

    $ sudo gem install cloudhead-mutter
    
That's it!
----------

_have fun_

Footnote
--------

This code is _highly experimental_, don't try this at home!
