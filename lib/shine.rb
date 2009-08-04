# Copyright (c) 2009 Garry Hill <garry@magnetised.info>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
    options = options.reject { |k, v| !v }
    params = {}
    begin
      files = filepaths.map {|f| File.open(f) }
      filepaths.each_with_index do |f, i|
        params["file#{i.to_s.rjust(4, "0")}"] = UploadIO.new(f, MIME[format], filepaths[i])
      end
      req = Net::HTTP::Post::Multipart.new(url.path, params.merge(options))
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
    options = options.reject { |k, v| !v }
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

    def self.file(f, options={})
      self.files(f, options)
    end

    def self.files(input_files, options={})
      input_files = [input_files] unless input_files.is_a?(Array)
      input_files.flatten!
      compressor = Shine::JS::Compressor.new(input_files)
      compressor.compress(options)
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
