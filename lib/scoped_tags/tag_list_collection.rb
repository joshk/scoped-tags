class TagListCollection < TagListProxy
  
  self.class.instance_eval do
    attr_accessor :delimiter
  end
  
  
  def <<(tag_names)
    tag_names = clean_tag_list(tag_names)
    current_list = self.to_a
    context_tags = self.proxy_owner.send(self.proxy_context)
    tag_names.each do |new_tag|
      unless current_list.include?(new_tag)
        context_tags << Tag.find_or_new_by_name_and_context(new_tag, self.proxy_context.to_s) 
      end
    end
    self
  end
  
  alias_method :push, :<<
  alias_method :concat, :<<
  
  
  def delete(tag_names)
    context_tags = self.proxy_owner.send(self.proxy_context)
    to_delete = []
    tag_names = clean_tag_list(tag_names)
    context_tags.each do |tag|
      to_delete << tag if tag_names.include?(tag.name)
    end
    context_tags.delete(to_delete)
    to_delete.collect(&:name)
  end
  
  def delete_at(index)
    context_tags = self.proxy_owner.send(self.proxy_context)
    return nil if 0 > index or index > context_tags.size
    tag_at_index = context_tags[index]
    context_tags.delete(tag_at_index)
    tag_at_index
  end
  
  def pop
    self.delete_at(self.size - 1)
  end
  
  def replace(tag_names)
    new_uniq_list = clean_tag_list(tag_names).uniq
    new_tag_list = new_uniq_list.inject([]) do |list, tag_name|
      list << Tag.find_or_new_by_name_and_context(tag_name, self.proxy_context)
      list
    end
    context_tags = self.proxy_owner.send(self.proxy_context)
    context_tags.replace(new_tag_list)
    self
  end
  
    
  def to_s
    self.join("#{TagListCollection.delimiter} ")
  end
  
  
  private
  
    def find_target
      association = self.proxy_owner.send proxy_context
      association.collect(&:name)
    end
    
    def clean_tag_list(tags)
      tags = tags.is_a?(Array) ? tags : tags.split(TagListCollection.delimiter)
      tags.collect(&:strip).reject(&:blank?)
    end
  
end