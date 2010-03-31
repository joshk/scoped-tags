require 'rubygems'

require 'spec'
require 'shoulda'

require 'sqlite3' # So we don't get Encoding errors which we get with plain sqlite3

require 'active_support'
require 'active_record'

require 'scoped-tags'


def reload_database
  load(File.expand_path('../schema.rb', __FILE__))
end

Spec::Runner.configure do |config|
  config.include(Shoulda::ActiveRecord::Matchers, :type => :model)

  config.before(:suite) do
    ActiveRecord::Base.logger = Logger.new(File.expand_path("../debug.log", __FILE__))
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
    reload_database
  end
end

class ScopedTaggedModel < ActiveRecord::Base
  scoped_tags :genres
end

class UnScopedTaggedModel < ActiveRecord::Base
end