mutter
======

> my words come out,
>   in color and style

mutter is a tiny CLI library, with a focus on style.
use it in your apps to have better looking command-line output!

usage
-----

    require 'mutter'

    mut = Mutter.new
    mut.say "hello _world_"      # underlines 'world'
    mut.say "hello world", :bold # bolds 'hello world'

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

Have fun!
---------