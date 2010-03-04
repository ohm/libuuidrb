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

  desc 'valgrind functional tests'
  task :valgrind do
    opts = %W(
      --partial-loads-ok=yes
      --undef-value-errors=no
      --leak-check=full
    )

    sh "valgrind #{opts.join(' ')} ruby test/test_functionality.rb"
  end
rescue LoadError => le
  puts "#{le.message}"
end
