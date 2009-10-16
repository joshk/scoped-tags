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
    
    it "should change the entire list when using genre_list= with a comma seperated list of tags" do
      @scoped_model.genre_list = 'blues, rock, country'
      @scoped_model.genres.size.should == 3
      @scoped_model.genre_list.should == ["rock", "blues", "country"]
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
    
    it "#tagged_with_genres" do
      tag = 'pop'
      
      @scoped_model.genre_list << tag
      @scoped_model.save!
      
      ar_check = ScopedTaggedModel.all(:conditions => ['tags.name IN (?) AND tags.context = ?', tag, 'genres'], :include => [:taggings, :tags])
      ar_check.size.should == 1
      
      ScopedTaggedModel.methods.should include('tagged_with_genres')
      
      st_check = ScopedTaggedModel.tagged_with_genres(tag)
      st_check.size.should == 1
      st_check.first.id.should == @scoped_model.id
    end
    
    it "#tagged_with_genres with options" do
      tag = 'pop'
      
      ScopedTaggedModel.delete_all
      options_check1 = ScopedTaggedModel.new
      options_check1.genre_list << tag
      options_check1.save!
      
      options_check2 = ScopedTaggedModel.new
      options_check2.genre_list << tag
      options_check2.save!
      
      st_check = ScopedTaggedModel.tagged_with_genres(tag, :limit => 1)
      st_check.size.should == 1
      st_check.first.id.should == options_check1.id
    end
    
    it "#tagged_with_genres with options and multiple tags in an array" do
      tag = ['pop', 'techno', 'dance']
      
      ScopedTaggedModel.delete_all
      options_check1 = ScopedTaggedModel.new
      options_check1.genre_list << tag
      options_check1.save!
      
      options_check2 = ScopedTaggedModel.new
      options_check2.genre_list << tag
      options_check2.save!
      
      st_check = ScopedTaggedModel.tagged_with_genres(tag, :limit => 1)
      st_check.size.should == 1
      st_check.first.id.should == options_check1.id
    end
    
    it "#tagged_with_genres with options and multiple tags in a string" do
      tag = 'pop, techno, dance'
      
      ScopedTaggedModel.delete_all
      options_check1 = ScopedTaggedModel.new
      options_check1.genre_list << tag
      options_check1.save!
      
      options_check2 = ScopedTaggedModel.new
      options_check2.genre_list << tag
      options_check2.save!
      
      st_check = ScopedTaggedModel.tagged_with_genres(tag, :limit => 1)
      st_check.size.should == 1
      st_check.first.id.should == options_check1.id
    end
  end
end 
