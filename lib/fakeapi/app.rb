require 'sinatra/base'

module FakeAPI
  class App < Sinatra::Base
    attr_reader :data

    def initialize(*)
      super
      @data = {}
    end

    def self.test(method_name, &call_block)
      TestRun.new(self, method_name, call_block).run
    end
  end
end
