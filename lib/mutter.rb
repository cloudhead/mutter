#
# Mutter — the tiny command-line interface library with lots of style~
#

require 'yaml' 

$:.unshift File.dirname(__FILE__) + '/mutter'

require 'mutterer'
require 'indenter'
require 'ext'

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
  
  def self.indenter tab
    Indenter.new tab
  end
  
  def self.say *args
    new.say *args
  end
  
  def self.stylize *args
    new.stylize *args
  end
  
  def self.new *args
    Mutterer.new(*args)
  end
end