class TagList < Array
  cattr_accessor :delimiter
  @@delimiter = ','
  
  def initialize(list, taggable_instance, context)
    list = list.is_a?(Array) ? list : list.split(@@delimiter).collect(&:strip).reject(&:blank?)
    @taggable_instance = taggable_instance
    @context = context
    super list
  end
  
  def to_s
    join(', ')
  end
  
  def <<(new_tags)
    new_tags = split_and_sanatize(new_tags)
    new_tags.each do |tag|
      next if self.include?(tag)
      @taggable_instance.send :add_tag_to_list, @context, tag
    end
    self.push(@taggable_instance.send(:get_tag_list, @context))
    self.flatten!.uniq!
  end
  
  def delete(tag_list)
    split_tag_list = split_and_sanatize(tag_list)
    @taggable_instance.send :remove_tag, split_tag_list, @context
    self.replace(@taggable_instance.send :get_tag_list, @context)
    tag_list
  end
  
  
  private
    def split_and_sanatize(tag_list)
      tag_list = tag_list.split(@@delimiter) if tag_list.is_a?(String)
      tag_list = tag_list.reject(&:blank?).collect{ |tag| tag.strip.squeeze(' ') }
      tag_list
    end
end