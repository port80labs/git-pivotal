require 'spec_helper'

describe Commands::Story do

  before(:each) do
    # stub out git config requests
    Commands::Story.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")

    @story = Commands::Story.new
  end
  
  it "should specify its story type" do
    @story.type.should == "story"
  end
  
  it "should specify a plural for its story types" do
    @story.plural_type.should == "stories"
  end
  
  it "should specify its branch suffix" do
    @story.branch_suffix.should == "story"
  end
  
end

