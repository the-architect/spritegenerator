require "rubygems"
require "bundler"
Bundler.setup(:default)
require 'yaml'
require 'ostruct'
require 'RMagick'
require 'liquid'

require File.expand_path('../sprites/generator', __FILE__)
require File.expand_path('../sprites/batch', __FILE__)

module Sprites
  class Config
    class << self  
      def root=(root = nil)
        @root = root
      end
      
      def root
        @root || File.expand_path('../../', __FILE__)
      end
    end
  end
end