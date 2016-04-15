#!/usr/bin/env ruby

# file: rpi_rgb.rb

require 'rpi_led'


# Example

=begin

presets = {
  purple: [100,0,100], 
  yellow: [75, 40, 5, 100],
  orange: [20, 3, 0],
  lilac: [20, 3, 60],
  turquoise: [1, 10, 10]
}

rgb =  RPiRGB.new(%w(27 17 4), presets: presets, smooth: true)
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

class RPiRGB

  attr_accessor :brightness
  attr_reader :red, :green, :blue

  def initialize(pins, brightness: 100, smooth: false, presets: nil, \
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
    
    values.flatten!
    
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
  
  def off()
    [@red, @green, @blue].each(&:off)
  end
  

end