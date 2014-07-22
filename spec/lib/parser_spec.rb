require './parser.rb'

describe StructHash do
  # this behavior can be defined by having 'super' instead of 'nil'
  # please see : http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  # it 'returns an error if the key does not exist' do
  #   expect { StructHash.new.foo }.to raise_error(NoMethodError)
  # end

  it 'returns nil if the key does not exist' do
    expect(StructHash.new.foo).to eq nil
  end
end

describe Parser do
  let(:config) do
    load_config('./hello.ini', ["ubuntu", :production])
  end

  let(:config_two) do
    load_config('./hello.ini', ["staging", :production])
  end

  it 'parses integers' do
    expect(config.common.paid_users_size_limit).to eq(2147483648)
  end

  it 'parses strings in quotes' do
    expect(config.ftp.name).to eq("hello there, ftp uploading")
  end

  it 'parses arrays' do
    expect(config.http.params).to eq(["array", "of", "values"])
  end

  it 'parses booleans' do
    expect(config.ftp.enabled).to eq false
  end
 
  it 'returns the path for a given hash[:key]' do
    expect(config.ftp[:path]).to eq("/etc/var/uploads")
  end
  
  it 'returns a symbolized hash for a section with overrides' do
    expect(config.ftp).to eq name: "hello there, ftp uploading",
                             path: "/etc/var/uploads",
                             enabled: false
  end

  it 'returns the path for the last section defined with overrides' do
    expect(config.ftp[:path]).to eq("/etc/var/uploads")
    expect(config_two.ftp[:path]).to eq("/srv/uploads/")
  end

  it 'should not return the non-existing values' do
    expect(config.ftp.lastname).to eq nil

    # this is for expecting the no method error (see parser.rb:10)
    # expect(config.ftp.lastname).to raise_error(NoMethodError)
  end
end
