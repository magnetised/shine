require 'rubygems'
require 'net/http/post/multipart'

module Shine
  def self.compress_url
    URI.parse('http://shine.magnetised.info/compress')
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
    def self.compress(input_file)
      compressor = Shine::JS::Compressor.new(input_file)
      compressor.compress
    end

    def self.compress_all(input_files)
      compressors = input_files.map {|f| Shine::JS::Compressor.new(f)}
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
        Shine.compress_file(@filepath)
      end
    end
  end
end