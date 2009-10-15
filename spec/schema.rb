ActiveRecord::Schema.define :version => 0 do
  
  create_table "scoped_tagged_models", :force => true do |t|
    t.string :name
  end
  
  create_table "tags", :force => true do |t|
    t.string :name
    t.string :context
  end
  
  create_table "taggings", :force => true do |t|
    t.references :tag
    t.references :taggable, :polymorphic => true
  end
  
  create_table "people", :force => true do |t|
    t.string :name
  end
  
end
