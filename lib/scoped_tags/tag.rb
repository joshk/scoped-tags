class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
   
  validates_presence_of :context
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :context
  
  attr_accessible :name, :context
  
  before_validation :trim_spaces, :lowercase_name
  
  
  def ==(object)
    super || (object.is_a?(Tag) && self.name == object.name && self.context == object.context)
  end
  
  
  private
    def trim_spaces
      self.name.try(:strip!).try(:squeeze!, ' ')
      self.context.try(:strip!).try(:squeeze!, ' ')
    end
    
    def lowercase_name
      self.name.try(:downcase!)
      self.context.try(:downcase!)
    end
end