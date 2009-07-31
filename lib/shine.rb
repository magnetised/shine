require 'rubygems'
require 'net/http/post/multipart'

module Shine
  class CompressionError < Exception; end

  MIME = {
    :js => "text/javascript",
    :css => "text/css"
  }
  @_server = nil

  def self.default_server
    "http://shine.magnetised.info"
  end
  def self.server
    @_server || default_server
  end

  def self.server=(url)
    @_server = url
  end

  def self.compress_url(format=:js)
    # URI.parse("http://shine.magnetised.info/#{format}")
    URI.parse("#{server}/#{format}")
  end

  def self.compress_js(filepaths, options={})
    compress_files(filepaths, :js, options)
  end

  def self.compress_css(filepaths, options={})
    compress_files(filepaths, :css, options)
  end

  def self.compress_files(filepaths, format=nil, options={})
    filepaths = [filepaths] unless filepaths.is_a?(Array)
    url = compress_url(format)
    params = {}
    begin
      files = filepaths.map {|f| File.open(f) }
      filepaths.each_with_index do |f, i|
        params["file#{i.to_s.rjust(4, "0")}"] = UploadIO.new(f, MIME[format], filepaths[i])
      end
      req = Net::HTTP::Post::Multipart.new(url.path, params)
      result = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      case result
      when Net::HTTPSuccess
        result.body
      else
        concatenate_files(files)
      end
    ensure
      files.each { |f| f.close rescue nil }
    end
  end

  def self.concatenate_files(files)
    files.map {|f| f.read }.join("\n")
  end

  def self.compress_string(source, format=nil, options={})
    url = compress_url(format)
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({'source' => source}.merge(options))
    result = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    case result
    when Net::HTTPSuccess
      result.body
    else
      source
    end
  end

  module JS
    def self.in_place(input_file_path)
      compressor = Shine::JS::Compressor.new(input_file_path)
      compressor.compress_in_place
    end

    def self.string(js, options={})
      begin
        Shine.compress_string(js, :js, options)
      rescue CompressionError
        js
      end
    end
    def self.file(f)
      self.files([f])
    end
    def self.files(*input_files)
      input_files.flatten!
      compressor = Shine::JS::Compressor.new(input_files)
      compressor.compress
    end

    class Compressor
      def initialize(filepaths)
        @filepaths = filepaths
      end

      def compress(options={})
        Shine.compress_js(@filepaths, options)
      end

      def compress_in_place(options={})
        @filepaths.each do |p|
          c = Shine.compress_js(p, options)
          File.open(p, 'w') { |f| f.write(c) }
        end
      end
    end
  end
end
