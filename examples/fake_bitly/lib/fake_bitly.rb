$:.unshift File.dirname(__FILE__) + '/../../../lib'
require 'fakeapi'

class FakeBitly < FakeAPI::App
end
