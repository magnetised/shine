require 'rubygems'
require 'net/http/post/multipart'

module Shrimp
  def self.compress_url
    URI.parse('http://shrimp.magnetised.info/compress')
  end
  def self.compress_file(filepath, params={})
    url = compress_url
    File.open(filepath) do |file|
      req = Net::HTTP::Post::Multipart.new(url.path, 'file' => UploadIO.new(file, 'text/javascript', filepath))
      result = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      result.body
    end
  end

  module JS
    def self.compress(input_files)
      compressors = input_files.map {|f| Shrimp::JS::Compressor.new(f)}
      compressed = []
      compressors.each do |c|
        compressed << c.compress
      end
      compressed
    end

    class Compressor
      def initialize(filepath)
        @filepath = filepath
      end

      def compress(options={})
        Shrimp.compress_file(@filepath)
      end
    end
  end
end
