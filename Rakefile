require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs = ['lib']
end

task :default  => :spec


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
