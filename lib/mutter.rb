require 'yaml'

module Mutter
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
    
    def initialize obj = {}
      @active, @styles = [], {}
      load File.dirname(__FILE__) + "/defaults"
      
      case obj
        when Hash
          obj = obj.inject({}) do |h, (k, v)|
            h.merge k => 
              (v.is_a?(Hash) ? v : { :match => v, :style => [k].flatten })
          end
          @styles.merge! obj
        when Array
          @active = obj
        when Symbol
          self.<< obj
        when String
          load obj
        else raise ArgumentError
      end
    end
    
    def load styles
      styles += '.yml' unless styles =~ /\.ya?ml/
      styles = YAML.load_file(styles).inject({}) do |h, (key, value)|
        value = { :match => value['match'], :style => value['style'] }
        h.merge key.to_sym => value
      end
      @styles.merge! styles
    end
    
    def say str, *styles
      out = stylize(parse(str), @active + styles)
      self.class.stream.write out.gsub(/\e(\d+)\e/, "\e[\\1m") + "\n"
      self.class.stream.flush
    end
    alias :print say
    
    def watch
      begin
        yield
      rescue Interrupt
        puts
        exit 0
      end
    end
    
    def << style
      @active << style
    end
    
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
    
    def esc style
      "\e#{style}\e"
    end
    
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