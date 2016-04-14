#!/usr/bin/env ruby

# file: rpi_rgb.rb

require 'rpi_led'


# Example

=begin

rgb =  RPiRGB.new(%w(4 17 27), presets: {purple: [100,100,0]})
rgb.color = 'white'
sleep 2
rgb.color = 'purple'
sleep 2
rgb.color = 'green'

=end

class RPiRGB

  attr_accessor :brightness
  attr_reader :red, :green, :blue

  def initialize(pins, brightness: 100, smooth: false, presets: nil)
    
    @red, @green, @blue = pins.map do |x| 
      RPiLed.new(x, brightness: brightness, smooth: smooth)
    end
    
    @brightness, @presets = brightness, presets 

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

    case val

    when 'red'
      mix 100, 0, 0

    when 'green'
      mix 0, 100, 0

    when 'blue'
      mix 0, 0, 100

    when 'white'
      mix 100, 100, 100

    else
      
      return unless @presets

      preset = @presets[val.to_sym]

      mix(preset) if preset

    end
  end
  
  def colour()
    @colour
  end

  alias color= colour=
  alias color colour
  
  def mix(*values)
    
    r, g, b = values.flatten.map {|v| v / (100 / @brightness ) }
    
    [@red, @green, @blue].each(&:on)
    
    red.brightness, green.brightness, blue.brightness = r, g, b
  end
  
  def off()
    [@red, @green, @blue].each(&:off)
  end
  

end