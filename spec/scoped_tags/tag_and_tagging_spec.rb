require File.dirname(__FILE__) + '/../spec_helper'


describe Tagging do
  
  before(:all) do 
    reload_database
    Tagging.create!(:tag_id => 1, :taggable_id => 1, :taggable_type => "Context1") 
  end
  
  it { should belong_to(:tag) }
  it { should belong_to(:taggable) }
  it { should validate_uniqueness_of(:taggable_id).scoped_to(:tag_id, :taggable_type) }
  
  it { should allow_mass_assignment_of(:taggable_id)
       should allow_mass_assignment_of(:taggable_type)
       should allow_mass_assignment_of(:tag_id) }
  
  it { should_not allow_mass_assignment_of(:created_at)
       should_not allow_mass_assignment_of(:updated_at) }
       
  it { should have_db_index([:taggable_id, :taggable_type]) }
  
  it "should validate uniqueness of taggable_id scoped to tag_id and taggable type" do
    proc {
      Tagging.create!(:tag_id => 1, :taggable_id => 1, :taggable_type => "Context2")
    }.should_not raise_error
  end
  
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
  
  it { should have_db_index([:context, :name]) }
  
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
    reload_database # or we will have duplication
    
    Tag.create!(:name => 'pop', :context => 'genres')
    s = Tag.find_or_new_by_name_and_context('pop', 'genres')
    s.new_record?.should be_false
  end
end
