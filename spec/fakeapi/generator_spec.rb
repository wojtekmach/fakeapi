require 'fakeapi/generator'

describe FakeAPI::Generator do
  def generate(name)
    described_class.generate(name)
  end

  it 'return soruce code for method' do
    FakeAPI::VCRReader.stub(:read).with('vcr/shorten.yml') do
      {
        'request' =>
          {
            'uri' => 'http://api.bitly.com/api/v3/shorten?longUrl=foo',
            'method' => 'get',
          },
        'response' =>
          {
            'status' => {'code' => 200},
            'headers' => {'Content-Type' => ['application/json']},
            'body' => {'string' => '{"message":"hello"}'},
          }
      }
    end

    generate('shorten').should == <<RUBY
  get '/api/v3/shorten' do
    status 200
    content_type 'application/json'
    body JSON(message: "hello")
  end
RUBY
  end
end
