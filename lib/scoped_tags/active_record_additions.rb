module ScopedTags

  module ActiveRecordAdditions

    def self.included(base)
      base.class_eval do
        def self.scoped_tags(contexts, options = nil)
          self.class.instance_eval{ attr_accessor :tag_contexts }

          raise ScopedTagsError, 'context is required for scoped-tags setup' if contexts.blank?

          self.tag_contexts = [contexts].flatten

          has_many :taggings,  :as => :taggable,       :class_name => 'Tagging', :dependent => :delete_all
          has_many :base_tags, :through => :taggings,  :class_name => 'Tag',     :source => :tag,   :readonly => true

          self.tag_contexts.each do |context|
            has_many context, :through => :taggings, :class_name => 'Tag',
                              :source  => :tag,
                              :conditions => { :tags => { :context => context.to_s.downcase } }

            c = context.to_s.singularize
            define_method("#{c}_list")   { get_tag_list(context) }
            define_method("#{c}_list=")  { |new_list| set_tag_list(context, new_list) }
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
        tag_names = tag_names.is_a?(Array) ? tag_names : tag_names.split(TagListCollection.delimiter)
        tag_names = tag_names.collect(&:strip).reject(&:blank?)

        required_options = { :include => [:taggings, :base_tags],
                             :conditions => ['tags.name IN (?) AND tags.context = ?', tag_names, context] }

        self.all(options.merge(required_options))
      end
    end


    module InstanceMethods
      protected
        def get_tag_list(context)
          @tag_list_collections = { } if not @tag_list_collections
          @tag_list_collections[context] ||= TagListCollection.new(self, context.to_s.downcase)
        end

        def set_tag_list(context, new_tags)
          get_tag_list(context).replace(new_tags)
        end
    end

  end

end