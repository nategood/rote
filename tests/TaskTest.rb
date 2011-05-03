require 'rubygems'
require 'require_relative'
require '../rote'
require 'minitest/autorun'

describe Task do 
  describe "parse task text" do
    before do
      @text = "Go do #something!!!"
      @what = "Go do something"
      @importance = 3
      @tags = ["something"]
      @parsed = Task.parse @text
    end
    it "should be parsed into a what, importance, and tags" do
      @parsed[:what].must_equal @what
      @parsed[:importance].must_equal @importance
      @parsed[:tags].must_equal @tags
    end
  end
end
