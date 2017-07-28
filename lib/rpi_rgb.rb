#!/usr/bin/env ruby

# file: rpi_rgb.rb

require 'rgb'
require 'rpi_led'


# Example

=begin

presets = {
  purple: '#800080', 
  yellow: '#FFFF00',
  orange: '#FFA500',
  turquoise: '#40E0D0',
  steelblue: '#4682B4'
}  

rgb =  RPiRGB.new(%w(27 17 22), presets: presets, smooth: true)
rgb.color = 'white'
sleep 2
rgb.color = 'purple'
sleep 2
rgb.color = 'green'
sleep 2
rgb.brightness = 4
sleep 2
rgb.color = 'yellow'

=end

# see also: 500+ Named Colours with rgb and hex values http://www.cloford.com/resources/colours/500col.htm

class RPiRGB

  attr_accessor :brightness
  attr_reader :red, :green, :blue

  def initialize(pins, brightness: 100, smooth: false, presets: {}, \
                 transition_time: 1.5)
    
    @red, @green, @blue = pins.map do |x| 
      RPiLed.new(x, brightness: brightness, smooth: smooth, \
                 transition_time: transition_time)
    end
    
    @brightness, @presets = brightness, presets
    @transition_time = transition_time
    @old_brightness = @brightness

  end

  def brightness=(val)
    
    @brightness = val
    [@red, @green, @blue].each do |led|
      b = led.brightness
      led.brightness = val if b > 0
    end
    
  end

  def colour=(val)
    
    @colour = val
    
    if val.is_a? String then
      
      return mix( RGB::Color.from_rgb_hex(val).to_rgb) if val =~ /^#/
      
      h = {red: '#FF0000', green: '#00FF00', blue: '#0000FF', white: '#FFFFFF'}
              
      color = h.merge(@presets)[val.to_sym]
      
      if color then
        
        if color =~ /^#/ then
          mix( RGB::Color.from_rgb_hex(color).to_rgb) 
        else
          mix color
        end
      end
      
    elsif val.is_a? Array
      mix val
    end
  end
  
  def colour()
    @colour
  end

  alias color= colour=
  alias color colour
  
  def mix(*rgb_values)    
    
    values = rgb_values.flatten.map {|x| (x * 0.392).round }
    
    r, g, b = if values.length < 4 then
      
      self.brightness = @old_brightness
      values.map {|v| v / (100.0 / @brightness ) }
      
    else
      
      @old_brightness = @brightness
      self.brightness = values.pop
      sleep @transition_time if @smooth
      values
      
    end
    
    [@red, @green, @blue].each(&:on)
    
    red.brightness, green.brightness, blue.brightness = r, g, b
  end
  
  def blink(seconds=0.5, duration: nil)
    [@red, @green, @blue].each{|x| x.blink(seconds, duration: duration) }
  end  
  
  def off(durationx=nil, duration: nil)
    [@red, @green, @blue].each{|x| x.off(durationx, duration: duration) }
  end
  
  def on(durationx=nil, duration: nil)
    [@red, @green, @blue].each{|x| x.on(durationx, duration: duration) }
  end  
  

end