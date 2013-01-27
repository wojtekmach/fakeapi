require_relative '../lib/fake_bitly'
require 'dotenv'
require 'bitly'

Dotenv.load

describe FakeBitly do
  before do
    Bitly.use_api_version_3
    @bitly = Bitly.new(ENV.fetch('BITLY_USERNAME'), ENV.fetch('BITLY_APIKEY'))
  end

  it 'handles /v3/shorten' do
    hash = FakeBitly.test('shorten') { @bitly.shorten('http://google.com').user_hash }
    hash.should have(6).characters
  end
end
