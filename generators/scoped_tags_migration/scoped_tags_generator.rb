class ScopedTagsGenerator < Rails::Generator::Base 
  def manifest 
    record do |m| 
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "scoped_tags_migration"
    end
  end
end
