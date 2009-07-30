require 'spec/spec_helper'

describe Mutter do
  def out
    File.read("spec/out.txt")
  end
  
  before(:each) do
    Mutter::Mutterer.stream = File.new("spec/out.txt", 'w')
  end
  
  after(:all) do
    File.delete("spec/out.txt")
  end

  it "should output strings" do
    Mutter.say "hello mutter!"
    out.should == "hello mutter!\n"
  end
  
  it "should underline" do
    Mutter.say "_hello mutter!_"
    out.should == "\e[4mhello mutter!\e[24m\n"
  end
  
  it "should bold" do
    Mutter.say "*hello mutter!*"
    out.should == "\e[1mhello mutter!\e[22m\n"
  end
  
  it "should inverse" do
    Mutter.say "[hello mutter!]"
    out.should == "\e[7mhello mutter!\e[27m\n"
  end
  
  it "should escape glyphs" do
    Mutter.say "**hello * world**"
    out.should == "\e[1mhello * world\e[22m\n"
  end
  
  it "should set defaults at the instance level" do
    Mutter.new([:bold, :underline]).say "hello mutter!"
    out.should == "\e[4m\e[1mhello mutter!\e[22m\e[24m\n"
  end
  
  it "should set defaults at the method level" do
    Mutter.say "hello mutter!", :bold, :underline
    out.should == "\e[4m\e[1mhello mutter!\e[22m\e[24m\n"
  end
  
  it "should set defaults at both levels" do
    Mutter.new(:bold).say "hello mutter!", :underline, :yellow
    out.should == "\e[33m\e[4m\e[1mhello mutter!\e[22m\e[24m\e[0m\n"
  end
  
  describe "with custom styles" do
    it "should work with custom styles" do
      style = {
        :alert => {
          :match => '!', 
          :styles => ['bold', 'red']
        }
      }
      Mutter.new(style).say "alert!", :alert
    end
  
    it "should work with shorthand custom styles" do
      Mutter.new({:bold => '~'}).say "~hello mutter!~"
      out.should == "\e[1mhello mutter!\e[22m\n"
    end
  
    it "should color" do
      Mutter.new({:cyan => ['<', '>']}).say "<hello mutter!>"
      out.should == "\e[36mhello mutter!\e[0m\n"
    end
  
    it "should mix styles" do
      Mutter.new({:cyan => '~'}).say "_*hello* ~world~_"
      out.should == "\e[4m\e[1mhello\e[22m \e[36mworld\e[0m\e[24m\n"
    end
  
    it "should color backgrounds" do
      Mutter.new({:cyan => '~'}).say "~[hello mutter!]~"
      out.should == "\e[36m\e[7mhello mutter!\e[27m\e[0m\n"
    end
  
    it "should work with multiple shorthand styles" do
      Mutter.new({[:cyan, :underline] => '~'}).say "~hello mutter!~"
      out.should == "\e[4m\e[36mhello mutter!\e[0m\e[24m\n"
    end
    
    it "should load styles from a yaml" do
      Mutter.new("spec/style").say "{important message!}"
      out.should == "\e[33m\e[4m\e[1mimportant message!\e[22m\e[24m\e[0m\n"
    end
  end
  
  it "should parse a complex string" do
    m = Mutter.new({:cyan => ['<','>']})
    m.say "hello *mutter*, would you _<please be quiet>_ for this <[test]>?"
    out.should == "hello \e[1mmutter\e[22m, would you \e[4m\e[36mplease be quiet\e[0m\e[24m for this \e[36m\e[7mtest\e[27m\e[0m?\n"
  end
end