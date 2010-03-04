# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{libuuidrb}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sebastian Ohm"]
  s.date = %q{2010-03-04}
  s.description = %q{libuuidrb uses libuuid to generate DCE compatible universally unique identifiers}
  s.email = %q{}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["LICENSE", "README", "ext/extconf.rb", "ext/lib_uuid.c", "ext/lib_uuid.h", "ext/uuid_base64.c", "ext/uuid_base64.h", "libuuidrb.gemspec"]
  s.files = ["LICENSE", "Manifest", "README", "Rakefile", "ext/extconf.rb", "ext/lib_uuid.c", "ext/lib_uuid.h", "ext/uuid_base64.c", "ext/uuid_base64.h", "libuuidrb.gemspec", "test/test_compatibility.rb", "test/test_functionality.rb"]
  s.homepage = %q{http://github.com/ohm/libuuidrb}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Libuuidrb", "--main", "README"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{libuuidrb}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{libuuidrb uses libuuid to generate DCE compatible universally unique identifiers}
  s.test_files = ["test/test_functionality.rb", "test/test_compatibility.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
