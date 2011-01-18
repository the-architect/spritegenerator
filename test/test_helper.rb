require "rubygems"
require "bundler"
Bundler.setup(:default, :test)
require File.expand_path('../../lib/sprites', __FILE__)

require 'test/unit'
require 'mocha'
require 'shoulda'

