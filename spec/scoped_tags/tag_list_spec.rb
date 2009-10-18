require File.dirname(__FILE__) + '/../spec_helper'


describe TagListCollection do
  
  before(:each) do
    @sm = ScopedTaggedModel.new
    @tlc = TagListCollection.new(@sm, :genres)
  end
  
  it "#delimiter" do
    TagListCollection.delimiter.should == ','
    TagListCollection.delimiter = '-'
    TagListCollection.delimiter.should == '-'
    TagListCollection.delimiter = ','
    TagListCollection.delimiter.should == ','
  end
  
  it ".proxy_owner" do
    @sm.genre_list.proxy_owner.should == @sm
  end
  
  it ".===" do
    @sm.genre_list << "disco"
    @sm.genre_list.should === ['disco']
  end
  
  it "should return an array with the class method is called (think its an array)" do
    @tlc.class.should == Array
  end
  
  it "should return the tag names in the genre list" do
    @sm.genres << Tag.new(:name => 'pop', :context => 'genres')
    @sm.genres << Tag.new(:name => 'rock', :context => 'genres')
    @sm.genre_list.should == ['pop', 'rock']
  end
  
  it "should add a tag to the tag list when the association << method is used" do
    @sm.genre_list.should == []
    @sm.genres << Tag.new(:name => 'rock', :context => 'genres')
    @sm.genre_list.should == ['rock']
  end
  
  it "should be able to be add a new tag word using <<" do
    @sm.genre_list << "disco"
    @sm.genre_list.should include('disco')
  end
  
  it "should be able to be add a new tag word using push" do
    @tlc.push('techno')
    @tlc.should include('techno')
  end
  
  it "should be able to be add a new tag word using concat" do
    @tlc.concat('dance')
    @tlc.should include('dance')
  end
  
  it "should be able to add delimited lists of tags" do
    @tlc << "techno, house"
    @tlc.should include('techno')
    @tlc.should include('house')
    @tlc.size.should == 2
  end
  
  it "should be able to delete tags using delete" do
    @tlc << 'rock'
    @sm.genres.size.should == 1
    @tlc.delete('rock')
    @tlc.should_not include('rock')
    @sm.genres.size.should == 0
  end
  
  it "should be able to delete tags using delete_at" do
    @tlc << 'rock' << 'pop' << 'disco'
    @sm.genres.size.should == 3
    @sm.save!
    @tlc.delete_at(0)
    @tlc.should_not include('rock')
    @sm.genres.size.should == 2
    @sm.save!
    @sm.reload
    @sm.genres.size.should == 2
  end
  
  it "should be able to delete tags using pop" do
    @tlc << 'rock' << 'pop' << 'disco'
    @sm.genres.size.should == 3
    @sm.genre_list.last.should == 'disco'
    @tlc.pop
    @tlc.should_not include('disco')
    @sm.save!
    @sm.reload
    @sm.genres.size.should == 2
  end
  
  it "should give a delimited list of words when converted to string" do
    @tlc << 'rock' << 'pop'
    @tlc.to_s.should == "rock, pop"
  end
  
  it "should not add duplicate tags" do
    @tlc << 'rock' << 'pop' << 'disco'
    @sm.genres.size.should == 3
    @tlc.should == ['rock', 'pop', 'disco']
    @tlc << "rock"
    @tlc.should == ['rock', 'pop', 'disco']
    @sm.genres.size.should == 3
  end
  
  it ".replace" do
    @tlc << 'rock' << 'pop' << 'disco'
    @sm.genre_list.should == ['rock', 'pop', 'disco']
    @sm.genre_list = ['funk', 'house']
    @sm.genre_list.should == ['funk', 'house']
  end
  
  it ".to_param" do
    @sm.genre_list = ['funk', 'house']
    @sm.genre_list.to_param.should == 'funk/house'
  end
  
end