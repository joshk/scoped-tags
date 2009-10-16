require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test


desc 'Generate documentation for the scoped_tags plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'scoped-tags'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name    = "scoped-tags"
    gemspec.summary = "Scoped tagging plugin for your rails models which keeps your associations in sync with your tag arrays"
    gemspec.author  = "Josh Kalderimis"
    gemspec.email   = "josh.kalderimis@gmail.com"
    gemspec.homepage = "http://github.com/joshk/scoped-tags"
    
    gemspec.files = FileList[
        "generators/**/*",
        "install.rb",
        "lib/**/*.rb",
        "MIT-LICENSE",
        "readme.md",
        "VERSION.yml",
        "uninstall.rb"
      ]
    gemspec.test_files = FileList["spec/**/*"]
    
    gemspec.add_dependency 'activerecord', '>= 2.3.3'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
