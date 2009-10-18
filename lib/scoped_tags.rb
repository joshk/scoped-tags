require 'scoped_tags/active_record_additions'
require 'scoped_tags/tag'
require 'scoped_tags/tagging'
require 'scoped_tags/tag_list_proxy'
require 'scoped_tags/tag_list_collection'

module ActiveRecord
  Base.class_eval do
    include ScopedTags::ActiveRecordAdditions
  end
end

TagListCollection.delimiter = ','