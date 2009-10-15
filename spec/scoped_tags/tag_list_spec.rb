require File.dirname(__FILE__) + '/../spec_helper'

describe TagList do
  before(:each) do
    @taggable = ScopedTaggedModel.new
    @taggable.genre_list = ["rock","pop"]
    @tag_list = @taggable.genre_list
  end
  
  it "should be an array" do
    @tag_list.is_a?(Array).should be_true
  end
  
  it "should be able to be add a new tag word" do
    @tag_list << "disco"
    @tag_list.include?("disco").should be_true
  end
  
  it "should be able to add delimited lists of tags" do
    @tag_list << "techno, house"
    @tag_list.include?("techno").should be_true
    @tag_list.include?("house").should be_true
    @tag_list.size.should == 4
  end
  
  it "should be able to delete tags" do
    @tag_list.delete("rock")
    @tag_list.include?("rock").should be_false
    @taggable.genre_list.include?("rock").should be_false
    @taggable.genres.size.should == 1
  end
  
  it "should be able to remove delimited lists of words" do
    @tag_list.delete("rock, pop")
    @tag_list.should be_empty
  end
  
  it "should give a delimited list of words when converted to string" do
    @tag_list.to_s.should == "rock, pop"
  end
  
  it "should not add duplicate tags" do
    @tag_list << "rock"
    @tag_list.to_s.should == "rock, pop"
    @taggable.genres.size.should == 2
  end
end