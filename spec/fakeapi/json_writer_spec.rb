require 'fakeapi/json_writer'

describe FakeAPI::JSONWriter do
  def write(json)
    described_class.write(json)
  end

  it 'handles strings' do
    write("hello").should == 'JSON("hello")'
  end

  it 'handles arrays' do
    write([1, 2]).should == 'JSON([1, 2])'
  end

  it 'handles hashes' do
    write(a: 1, b: 2).should == 'JSON(a: 1, b: 2)'
  end

  it 'handles hashes with string keys' do
    write("a" => 1).should == 'JSON("a"=>1)'
  end

  it 'handles arrays of hashes' do
    write([{a: 1}]).should == 'JSON([{a: 1}])'
  end

  it 'handles nested arrays' do
    write(a: {b: 1}).should == 'JSON(a: {b: 1})'
  end
end
