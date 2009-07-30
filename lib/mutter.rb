require 'yaml'
#
# Mutter — the tiny command-line interface library with lots of style~
#
module Mutter
  #
  # ANSI color & style codes
  #
  #   if the value's an array, it 
  #   represents [0] is the start code
  #   and [1] is the end code.
  #
  #   if the value is an int, it represents
  #   the start code, and the end code will be 0
  #
  ANSI = {
    :bold      => [1, 22],
    :underline => [4, 24],
    :inverse   => [7, 27],
    
    :black  => 30, :red    => 31,
    :green  => 32, :yellow => 33,
    :blue   => 34, :purple => 35,
    :cyan   => 36, :white  => 37
  }
  
  class Mutterer
    @stream = STDOUT
    
    # Initialize the styles, and load the defaults from +defaults.yml+
    #
    # @active: currently active styles, which apply to the whole string
    # @styles: contains all the user + default styles 
    #
    def initialize obj = {}
      @active, @styles = [], {}
      load File.dirname(__FILE__) + "/defaults"
      
      case obj
        when Hash       # A style definition: expand quick-styles and merge with @styles
          obj = obj.inject({}) do |h, (k, v)|
            h.merge k => 
              (v.is_a?(Hash) ? v : { :match => v, :style => [k].flatten })
          end
          @styles.merge! obj
        when Array      # An array of styles to be activated
          @active = obj
        when Symbol     # A single style to be activated
          self.<< obj
        when String     # The path of a yaml style-sheet
          load obj
        else raise ArgumentError
      end
    end
    
    #
    # Loads styles from a YAML style-sheet, 
    #   and converts the keys to symbols
    #
    def load styles
      styles += '.yml' unless styles =~ /\.ya?ml/
      styles = YAML.load_file(styles).inject({}) do |h, (key, value)|
        value = { :match => value['match'], :style => value['style'] }
        h.merge key.to_sym => value
      end
      @styles.merge! styles
    end
    
    #
    # Output to the command-line
    #   we parse the string, but also apply a style on the whole string,
    #
    def say str, *styles
      out = stylize(parse(str), @active + styles)
      self.class.stream.write out.gsub(/\e(\d+)\e/, "\e[\\1m") + "\n"
      self.class.stream.flush
    end
    alias :print say
    
    #
    # Utility function, to make a block interruptible
    #
    def watch
      begin
        yield
      rescue Interrupt
        puts
        exit 0
      end
    end
    
    #
    # Add a style to the active styles
    #
    def << style
      @active << style
    end
    
    #
    # Parse a string to ANSI codes
    #
    #   if the glyph is a pair, we match [0] as the start
    #   and [1] as the end marker.
    #   the matches are sent to +stylize+
    #
    def parse string
      @styles.inject(string) do |str, (name, options)|
        glyph, styles = options[:match], options[:style]
        if glyph.is_a? Array
          str.gsub(/#{Regexp.escape(glyph.first)}(.+?)
                    #{Regexp.escape(glyph.last)}/x) { stylize $1, styles }
        else
          str.gsub(/(#{Regexp.escape(glyph)}+)(.+?)\1/) { stylize $2, styles }
        end
      end
    end
    
    #
    # Apply styles to a string
    #
    #   if the style is a default ANSI style, we add the start
    #   and end sequence to the string.
    #   
    #   if the style is a custom style, we recurse, sending
    #   the list of ANSI styles contained in the custom style.
    #
    def stylize string, styles = []
      [styles].flatten.inject(string) do |str, style|
        style = style.to_sym
        if ANSI.include? style
          open, close = ANSI[style]
          "#{esc(open)}#{str}#{esc(close || 0)}"
        else
          stylize(str, @styles[style][:style])
        end
      end
    end
    
    #
    # Escape a string, for later replacement
    #
    def esc style
      "\e#{style}\e"
    end
    
    #
    # Output stream (defaults to STDOUT)
    #   mostly for test purposes
    #
    def self.stream
      @stream
    end

    def self.stream= io
      @stream = io
    end
  end
  
  def self.say *args
    new.say *args
  end
  
  def self.new *args
    Mutterer.new(*args)
  end
end