module ScopedTags
  
  module ActiveRecordAdditions
    
    def self.included(base)
      base.class_eval do
        def self.scoped_tags(contexts, options = nil)
          self.class.instance_eval{ attr_accessor :tag_contexts }
          
          raise ScopedTagsError, 'context is required for scoped-tags setup' if contexts.blank?
          
          self.tag_contexts = [contexts].flatten
          
          has_many :taggings, :as => :taggable,       :class_name => 'Tagging', :dependent => :delete_all
          has_many :tags,     :through => :taggings,  :class_name => 'Tag',     :readonly => true
            
          self.tag_contexts.each do |context|
            has_many context, :through => :taggings, :class_name => 'Tag',
                              :source  => :tag,
                              :conditions => ['context = ?', context.to_s.downcase]
            
            c = context.to_s.singularize
            define_method("#{c}_list")   { get_tag_list(context.to_s.downcase) }
            define_method("#{c}_list=")  { |new_list| set_tag_list(context.to_s.downcase, new_list) }
            self.class.instance_eval do
              define_method("tagged_with_#{context}") { |*args| find_tagged_with(args.first, context.to_s, args.extract_options!) }
            end
          end          
          
          self.send :extend,  ClassMethods
          self.send :include, InstanceMethods
        end
      end
    end
    
    
    module ClassMethods
      def find_tagged_with(tag_names, context, options = {})
        tag_array = TagList.new(tag_names, nil, nil)
        required_options = { :include => [:taggings, :tags], 
                             :conditions => ['tags.name IN (?) AND tags.context = ?', tag_array, context] }
        self.all(options.merge(required_options))
      end
    end

    
    module InstanceMethods
      private
        def get_tag_list(context)
          context_tags = self.send context
          tag_names = context_tags.collect(&:name)
          TagList.new(tag_names, self, context)
        end
      
        def add_tag_to_list(context, new_tag)
          association = self.send context
          unless get_tag_list(context).include?(new_tag)
            association << Tag.find_or_new_by_name_and_context(new_tag, context)
          end
        end
      
        def set_tag_list(context, new_list)
          new_uniq_list = TagList.new(new_list, nil, nil)
          new_tag_list = new_uniq_list.inject([]) do |list, tag_name|
            list << Tag.find_or_new_by_name_and_context(tag_name, context)
            list
          end
          self.send "#{context}=".to_sym, new_tag_list
        end
      
        def remove_tag(tag_names, context)
          context_tags = self.send context
          to_delete = []
          context_tags.each do |tag|
            to_delete << tag if tag_names.include?(tag.name)
          end
          context_tags.delete(to_delete)
        end
    end
    
  end
  
end