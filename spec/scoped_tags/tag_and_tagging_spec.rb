require File.dirname(__FILE__) + '/../spec_helper'


describe Tagging do
  it { should belong_to(:tag) }
  it { should belong_to(:taggable) }
end


describe Tag do
  before(:all) { Tag.create!(:name => 'rock', :context => 'genres') }
  
  it { should have_many(:taggings).dependent(:delete_all) }
    
  it { should validate_uniqueness_of(:name).scoped_to(:context).case_insensitive }
  it { should validate_presence_of(:context) }
  
  it { should allow_mass_assignment_of(:name)
       should allow_mass_assignment_of(:context) }
  
  it { should_not allow_mass_assignment_of(:created_at)
       should_not allow_mass_assignment_of(:updated_at) }
  
  it "should trim and squeeze spaces from name and context before validation" do
    t = Tag.new(:name => ' rock   and      roll', :context => '   genres   ')
    t.valid?
    t.name.should == 'rock and roll'
    t.context.should == 'genres' 
  end
  
  it "should lowercase the name and context before validation" do
    t = Tag.new(:name => 'POP', :context => 'GENRES')
    t.valid?
    t.name.should == 'pop'
    t.context.should == 'genres'
  end
  
  it "should recognize that it is equal to another tag with the same name and context" do
    t = Tag.new(:name => 'pop', :context => 'genres')
    s = Tag.new(:name => 'pop', :context => 'genres')
    t.should == s
  end
  
  it "#find_or_new_by_name_ane_context" do
    Tag.create!(:name => 'pop', :context => 'genres')
    s = Tag.find_or_new_by_name_and_context('pop', 'genres')
    s.new_record?.should be_false
  end
end
