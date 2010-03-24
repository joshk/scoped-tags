class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  validates_uniqueness_of :taggable_id, :scope => [:tag_id, :taggable_type]
  
  attr_accessible :taggable_type, :taggable_id, :tag_id
end
