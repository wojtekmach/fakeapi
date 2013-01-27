# FakeAPI

FakeAPI = Sinatra + VCR

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fakeapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fakeapi

## Usage

Let's say you're building FakeBitly service.

0. (Optional) Due to incompatibility between webmock and artifice you
   have to use newer versions of webmock:

```ruby
# Gemfile
source :rubygems

gem 'fakeapi', path: '~/Code/vendor/fakeapi'
gem 'webmock', github: 'bblimke/webmock', ref: '2c596f'
gem 'rspec'
gem 'bitly'
```

1. Create fake service:

```ruby
# fake_bitly.rb
require 'fakeapi'

class FakeBitly < FakeAPI::App
end
```

2. Create a spec. You don't want to test FakeBitly endpoints directly.
   Instead use a client library. `FakeBitly.test` (inherited from
   `FakeAPI::App`) will try to use your fake service (using `Artifice`)
   and if that fails it will record the HTTP interaction (using `VCR`).

```ruby
# fake_bitly_spec.rb
require_relative './fake_bitly'
require 'bitly'

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
```

3. Run the spec:

```bash
% bundle exec rspec fake_bitly_spec.rb
#<BitlyError:  - ''>

Use generated code:

  get '/v3/shorten' do
    status 200
    content_type 'application/json; charset=utf-8'
    body JSON(status_code: 200, status_txt: "OK", data: {long_url: "http://google.com/", url: "http://bit.ly/ORN1fW", hash: "ORN1fW", global_hash: "LmvF", new_hash: 0})
  end

F

Failures:

  1) FakeBitly handles /v3/shorten
     Failure/Error: hash = FakeBitly.test('shorten') { @bitly.shorten('http://google.com').user_hash }
     NotImplementedError:
       NotImplementedError
```

4. Use generated code:

```ruby
# fake_bitly.rb
class FakeBitly < FakeAPI::App
  get '/v3/shorten' do
    status 200
    content_type 'application/json; charset=utf-8'
    body JSON(status_code: 200, status_txt: "OK", data: {long_url: "http://google.com/", url: "http://bit.ly/ORN1fW", hash: "ORN1fW", global_hash: "LmvF", new_hash: 0})
  end
end
```

5. Run specs:

```bash
% bundle exec rspec fake_bitly_spec.rb
.

Finished in 0.0497 seconds
1 example, 0 failures
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Wojciech Mach

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
