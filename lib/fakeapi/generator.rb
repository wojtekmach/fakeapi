require 'yaml'
require 'json'
require 'uri'

module FakeAPI
  class Generator
    def self.generate(*args)
      new(*args).generate
    end

    def initialize(name)
      @name = name
    end

    def generate
      hash = VCRReader.read("vcr/#{@name}.yml")

      http_method = hash['request']['method']
      url = URI(hash['request']['uri']).path
      status = hash['response']['status']['code']
      content_type = hash['response']['headers']['Content-Type'].first

      body = hash['response']['body']['string']

      body = if content_type =~ /json/i
               write_json(body)
             else
               write_text(body)
             end

      <<RUBY
  #{http_method} '#{url}' do
    status #{status}
    content_type '#{content_type}'
    body #{body}
  end
RUBY
    end

    def write_json(body)
      require_relative './json_writer'
      JSONWriter.write(JSON.parse(body, symbolize_names: true).to_hash)
    end

    def write_text(body)
      '"' + body + '"'
    end
  end

  class VCRReader
    def self.read(filename)
      hash = YAML.load_file(filename)
      request_hash = hash['http_interactions'][0]['request']
      response_hash = hash['http_interactions'][0]['response']

      {'request' => request_hash, 'response' => response_hash}
    end
  end
end
