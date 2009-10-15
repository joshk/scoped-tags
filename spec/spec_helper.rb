require 'spec'
require 'shoulda'

require 'active_support'
require 'active_record'

require 'scoped_tags'

Spec::Runner.configure do |config|
  config.include(Shoulda::ActiveRecord::Matchers, :type => :model)
end

TEST_DATABASE_FILE = 'spec/test.sqlite3'

File.unlink(TEST_DATABASE_FILE) if File.exist?(TEST_DATABASE_FILE)
ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3", "database" => TEST_DATABASE_FILE
)
 
load('schema.rb')

RAILS_DEFAULT_LOGGER = Logger.new("spec/debug.log")

class ScopedTaggedModel < ActiveRecord::Base
  scoped_tags :genres
end

class UnScopedTaggedModel < ActiveRecord::Base
end