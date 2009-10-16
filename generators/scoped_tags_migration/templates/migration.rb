class ScopedTagsMigration < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.string :context
    end

    create_table :taggings do |t|
      t.references :tag
      t.references :taggable, :polymorphic => true
    end

    add_index "tags", ['context', 'name']
    add_index "taggings", ['taggable_id', 'taggable_type']
  end
  
  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
