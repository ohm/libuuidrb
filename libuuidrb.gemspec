# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{libuuidrb}
  s.version = "0.1.0"

  s.authors = ["Sebastian Ohm"]
  s.description = %q{libuuidrb uses libuuid to generate DCE compatible universally unique identifiers}
  s.email = %q{}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["LICENSE", "README", "ext/extconf.rb", "ext/lib_uuid.c", "ext/lib_uuid.h", "ext/uuid_base64.c", "ext/uuid_base64.h", "libuuidrb.gemspec"]
  s.files = ["LICENSE", "Manifest", "README", "Rakefile", "ext/extconf.rb", "ext/lib_uuid.c", "ext/lib_uuid.h", "ext/uuid_base64.c", "ext/uuid_base64.h", "libuuidrb.gemspec", "test/test_compatibility.rb", "test/test_functionality.rb"]
  s.homepage = %q{http://github.com/ohm/libuuidrb}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Libuuidrb", "--main", "README"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{libuuidrb}
  s.summary = %q{libuuidrb uses libuuid to generate DCE compatible universally unique identifiers}
  s.test_files = ["test/test_functionality.rb", "test/test_compatibility.rb"]

  s.add_development_dependency 'rake-compiler'
end
