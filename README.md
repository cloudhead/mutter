mutter
======

> my words come out, 
  > in color and style

mutter is the tiny CLI library, with a focus on style.
use it in your apps to have better looking command-line output!

printing to the command-line
----------------------------

    require 'mutter'

    mut = Mutter.new
    mut.say "hello _world_"        # underlines 'world'
    mut.say "hello world", :bold   # bolds the whole string
    mut.say "hello [world]", :cyan # inverts 'world', and colors the string cyan

styles
------
mutter supports these styles:

    :bold, :underline, :inverse

and these colors:

    :red, :green, :blue, :yellow, :cyan, :purple, :white, :black

customization
-------------

    styles = {
      :warning => {
        :match => ['*!', '!*'],
        :style => ['yellow', 'bold']
      },
      :error => {
        :match => '!!',
        :style => ['red', 'underline']
      }
    }
    
    mut = Mutter.new(styles)
    mut.say "warning, warning!", :warning
    mut.say "gosh, we have an !!error!!"

mutter can also read styles from _YAML_ files, just give it the path, like so:

    Mutter.new("styles.yml")

There's an example style in `spec/`

have fun!
---------