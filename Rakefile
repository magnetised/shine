require 'rubygems'
# Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "Shine"
  s.version = "0.0.1"
  s.author = "Garry Hill"
  s.email = "garry@magnetised.info"
  s.homepage = "http://shine.magnetised.info/" s.platform = Gem::Platform::RUBY
  s.summary = "Shine provides a Java-free way to use the excellent YUI compressor"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "name"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("multipart-post", ">= 1.0")
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end

