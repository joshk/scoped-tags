# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scoped-tags}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Kalderimis"]
  s.date = %q{2010-03-31}
  s.email = %q{josh.kalderimis@gmail.com}
  s.files = [
    "MIT-LICENSE",
     "VERSION.yml",
     "generators/scoped_tags_migration/scoped_tags_migration_generator.rb",
     "generators/scoped_tags_migration/templates/migration.rb",
     "lib/scoped-tags.rb",
     "lib/scoped_tags/active_record_additions.rb",
     "lib/scoped_tags/tag.rb",
     "lib/scoped_tags/tag_list_collection.rb",
     "lib/scoped_tags/tag_list_proxy.rb",
     "lib/scoped_tags/tagging.rb",
     "readme.md"
  ]
  s.homepage = %q{http://github.com/joshk/scoped-tags}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Scoped tagging plugin for your rails models which keeps your associations in sync with your tag arrays}
  s.test_files = [
    "spec/debug.log",
     "spec/schema.rb",
     "spec/scoped_tags",
     "spec/scoped_tags/scoped_tags_spec.rb",
     "spec/scoped_tags/tag_and_tagging_spec.rb",
     "spec/scoped_tags/tag_list_spec.rb",
     "spec/spec_helper.rb",
     "spec/test.sqlite3"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.3"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3.3"])
  end
end

