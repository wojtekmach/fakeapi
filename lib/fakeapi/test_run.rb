require 'vcr'
require 'artifice'
require 'term/ansicolor'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr'
  c.hook_into :webmock
end

module FakeAPI
  class TestRun
    NET_HTTP = ::Net::HTTP

    def initialize(api, method_name, run_block)
      @api = api
      @method_name = method_name
      @run_block = run_block
    end

    def run
      begin
        run_with_artifice
      rescue => ex
        p ex
        run_with_vcr
      end
    end

    def run_with_artifice
      ret = nil
      Artifice.activate_with @api do
        ret = @run_block.call
      end
      ret
    end

    def run_with_vcr
      if ::Net::HTTP != NET_HTTP
        ::Net.class_eval do
          remove_const(:HTTP)
          const_set(:HTTP, NET_HTTP)
        end
      end

      VCR.use_cassette(@method_name, &@run_block)

      color = Term::ANSIColor

      puts
      puts color.green + 'Use generated code:' + color.clear
      puts
      puts color.yellow + FakeAPI::Generator.generate(@method_name) + color.clear

      raise NotImplementedError
    end
  end
end
