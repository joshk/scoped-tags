require File.dirname(__FILE__) + '/../spec_helper'


describe "ScopedTaggedModel" do   
  context "attaching scoped-tags to a model" do
    before(:each) do
      @scoped_model = ScopedTaggedModel.new 
    end
    
    it "should include the taggings method" do 
      @scoped_model.should respond_to(:taggings)
    end

    it "should include a tags method" do 
      @scoped_model.should respond_to(:tags)
    end

    it "should include the genres method" do 
      @scoped_model.should respond_to(:genres)
    end
    
    it "should at tag_contexts to the class" do
      ScopedTaggedModel.should respond_to(:tag_contexts)
    end
    
    it "should create a getter and setter context tag list" do
      @scoped_model.should respond_to(:genre_list, :genre_list=)
    end
  end
  
  context "using scoped-tags in an every day situation" do
    before(:each) do
      @scoped_model = ScopedTaggedModel.new 
      @scoped_model.genres << Tag.new(:name => 'rock', :context => 'genres')
    end
    
    it "should return the genres association name list when genre_list is called" do
      @scoped_model.genre_list.should include('rock')
    end
    
    it "should add a tag to the association when genre_list << is used" do
      @scoped_model.genre_list << 'pop'
      @scoped_model.genres.size.should == 2 
      @scoped_model.genre_list.should include('pop')
    end
    
    it "should change the entire list when using genre_list =" do
      @scoped_model.genre_list = 'blues'
      @scoped_model.genres.size.should == 1 
      @scoped_model.genre_list.should include('blues')
    end
    
    it "should only add uniq tags to the association" do
      @scoped_model.genre_list << 'blues'
      @scoped_model.genres.size.should == 2 
      @scoped_model.genre_list.should include('blues', 'rock')
      @scoped_model.genre_list << 'blues'
      @scoped_model.genre_list << 'blues'
      @scoped_model.genre_list << 'rock'
      @scoped_model.genres.size.should == 2
      @scoped_model.genre_list.should include('blues', 'rock')
    end
    
    it "should allow tags to be removed from the association and have the tag list act consistently" do
      @scoped_model.genre_list << 'blues'
      @scoped_model.genres.size.should == 2 
      @scoped_model.genres.delete(@scoped_model.genres.last)
      @scoped_model.genres.size.should == 1
      @scoped_model.genre_list.should include('rock')
    end
  end
end 
