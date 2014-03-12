require 'rake/extensiontask'
require 'rspec/core/rake_task'

Rake::ExtensionTask.new('lib_uuid') do |ext|
  ext.ext_dir = 'ext'
end

RSpec::Core::RakeTask.new(:spec => [:clean, :compile])

desc 'Valgrind functional specs'
task :valgrind do
  opts = %w(
    --partial-loads-ok=yes
    --undef-value-errors=no
    --leak-check=full
  )

  sh *['valgrind', opts, %w(ruby -S rspec spec/uuid_spec.rb)].flatten
end

task :default => :spec

begin
  require 'rubygems'
  require 'rake'
  require 'echoe'

  Echoe.new('libuuidrb', '0.1.0') do |p|
    p.author         = 'Sebastian Ohm'
    p.url            = 'http://github.com/ohm/libuuidrb'
    p.description    = 'libuuidrb uses libuuid to generate DCE compatible universally unique identifiers'
    p.ignore_pattern = ['tmp/*', 'script/*', 'benchmark/*']
    p.development_dependencies = []
  end
rescue LoadError => le
  puts "#{le.message}"
end
