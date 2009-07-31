require "rubygems"
require "rr"
require 'time'

require "spec" # Satisfies Autotest and anyone else not using the Rake tasks

require 'lib/shine'

Spec::Runner.configure do |config|
  config.mock_with(:rr)
end

def test_file(filename)
  r = File.join(File.dirname(__FILE__), 'fixtures')
  {:source => File.join(r, 'src', filename), :compressed => File.join(r, 'compressed', filename)}
end
