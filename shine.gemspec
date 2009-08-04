# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shine}
  s.version = "0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Garry Hill"]
  s.date = %q{2009-07-27}
  s.description = %q{shine provides YUI compression without the need for java to be installed}
  s.email = %q{garry@magnetised.info}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["README", "LICENSE", "Rakefile", "bin", "bin/compress", "lib", "lib/shine.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://shine.magnetised.info}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{shine provides YUI compression without the need for java to be installed.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multipart-post>, [">= 1.0"])
    else
      s.add_dependency(%q<multipart-post>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<multipart-post>, [">= 1.0"])
  end
end

