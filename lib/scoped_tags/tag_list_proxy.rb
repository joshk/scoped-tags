class TagListProxy

  alias_method :proxy_respond_to?, :respond_to?
  alias_method :proxy_extend, :extend
  delegate :to_param, :to => :proxy_target
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|proxy_|^object_id$)/ }

  def initialize(owner, context)
    @owner, @context = owner, context
    @target = nil
  end

  # Returns the owner of the proxy.
  def proxy_owner
    @owner
  end

  # Returns the \context of the proxy, same as +context+.
  def proxy_context
    @context
  end
  
  # Returns the \target of the proxy, same as +target+.
  def proxy_target
    @target
  end
  
  # Does the proxy or its \target respond to +symbol+?
  def respond_to?(*args)
    proxy_respond_to?(*args) || (load_target && @target.respond_to?(*args))
  end

  # Forwards <tt>===</tt> explicitly to the \target because the instance method
  # removal above doesn't catch it. Loads the \target if needed.
  def ===(other)
    reload
    other === @target
  end

  # Reloads the \target and returns +self+ on success.
  def reload
    @target = nil
    load_target
    self unless @target.nil?
  end

  # Returns the target of this proxy, same as +proxy_target+.
  def target
    @target
  end

  # Sets the target of this proxy to <tt>\target</tt>, and the \loaded flag to +true+.
  def target=(target)
    @target = target
  end

  # Forwards the call to the target. Loads the \target if needed.
  def inspect
    reload
    @target.inspect
  end

  def send(method, *args)
    if proxy_respond_to?(method)
      super
    else
      reload
      @target.send(method, *args)
    end
  end


  private
    # Forwards any missing method call to the \target.
    def method_missing(method, *args)
      if reload
        unless @target.respond_to?(method)
          message = "undefined method `#{method.to_s}' for \"#{@target}\":#{@target.class.to_s}"
          raise NoMethodError, message
        end

        if block_given?
          @target.send(method, *args)  { |*block_args| yield(*block_args) }
        else
          @target.send(method, *args)
        end
      end
    end

    def load_target
      @target = find_target
      @target
    rescue ActiveRecord::RecordNotFound
      reset
    end


end
