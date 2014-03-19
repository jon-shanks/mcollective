require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::client::keys' do
  let(:mco_etc) { '/etc/puppetlabs/mcollective' }

  context 'when it is defaults' do
    it { should_not contain_file }
  end

  context 'when shared public key set' do
    let(:params) { {:shared_public_key => 'this-pub-key.pem'} }

    it do
      should contain_file("#{mco_etc}/ssl/this-pub-key.pem").with({
        'ensure'  => 'present',
        'source'  => 'puppet:///modules/mcollective/this-pub-key.pem',
      })
    end
  end

  context 'when client_public_key set' do
    let(:params) { {:client_public_key => 'this-client-key.pem'} }

    it { should_not contain_file } 
  end

  context 'when both client public and private set' do
    let(:params) { {:client_public_key => 'client-pvt-key.pem', :client_private_key => 'client-pub-key.pem'} }

    it do
      should contain_file("#{mco_etc}/ssl/client-pub-key.pem").with({
        'ensure'    => 'present',
        'source'    => 'puppet:///modules/mcollective/clients/client-pub-key.pem',
      })

      should contain_file("#{mco_etc}/ssl/client-pvt-key.pem").with({
        'ensure'    => 'present',
        'source'    => 'puppet:///modules/mcollective/clients/client-pvt-key.pem',
      })
    end
  end
end
