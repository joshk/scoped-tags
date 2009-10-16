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
  
  add_index "tags", ['context', 'name']
  add_index "taggings", ['taggable_id', 'taggable_type']
  
end
