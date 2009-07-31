require File.join( File.dirname(__FILE__), "spec_helper" )

require 'tempfile'

describe Shine do
  it "should allow configuration of the server" do
    google = "http://shine.magnetised.info"
    Shine.server.should == Shine.default_server
    Shine.compress_url(:js).should == URI.parse("#{google}/js")
    local = "http://localhost:8080"
    Shine.server = local
    Shine.server.should == local
    Shine.compress_url(:js).should == URI.parse("#{local}/js")
    Shine.server = nil
    Shine.server.should == Shine.default_server
  end

  describe Shine::JS do
    before(:each) do
      # Shine.server = local
      @test_file1 = test_file('test01.js')
      @test_file2 = test_file('test02.js')
    end
    it "should compress a file in-place" do
      tempfile = Tempfile.new('shine-spec')
      tempfile.write(File.read(@test_file1[:source]))
      tempfile.flush
      Shine::JS.in_place(tempfile.path)
      File.read(tempfile.path).should == File.read(@test_file1[:compressed])
      tempfile.close
    end

    it "should compress a string" do
      source = File.read(@test_file1[:source])
      Shine::JS.string(source).should == File.read(@test_file1[:compressed])
    end
    it "should compress a file" do
      Shine::JS.file(@test_file1[:source]).should == File.read(@test_file1[:compressed])
    end
    it "should compress a list of files" do
      Shine::JS.files(@test_file1[:source], @test_file2[:source]).should == File.read(test_file('test-concat.js')[:compressed])
      Shine::JS.files([@test_file1[:source], @test_file2[:source]]).should == File.read(test_file('test-concat.js')[:compressed])
    end

    describe "Error handling" do
      before(:each) do
        # don't like using this but it works
        stub(Net::HTTP).start(anything, anything) { Net::HTTPServerException.new("", "") }
      end

      it "shouldn't touch an in-place file" do
        tempfile = Tempfile.new('shine-spec')
        tempfile.write(File.read(@test_file1[:source]))
        tempfile.flush
        Shine::JS.in_place(tempfile.path)
        File.read(tempfile.path).should == File.read(@test_file1[:source])
        tempfile.close
      end
      it "should return an unmodified string" do
        source = File.read(@test_file1[:source])
        Shine::JS.string(source).should == source
      end
      it "shouldn't alter any of a list of compressed files" do
        Shine::JS.files(@test_file1[:source], @test_file2[:source]).should == File.read(test_file('test-concat.js')[:source])
      end
    end
  end
end
