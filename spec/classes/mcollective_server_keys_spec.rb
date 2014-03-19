require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::server::keys' do
  let(:mco_etc) { '/etc/puppetlabs/mcollective' }

  context 'test with defaults' do
    ['nyx-mcollective-servers-public.pem','nyx-mcollective-servers-private.pem'].each { |f|
      it do
        should contain_file("#{mco_etc}/ssl/#{f}").with({
          'ensure'  => 'present',
          'source'  => "puppet:///modules/mcollective/#{f}",
        })
      end
    }

    it { should_not contain_mcollective__client_certs }

  end

  context 'when shared keys overriden' do
    let(:params) { {:shared_private_key => 'cert_one_pvt.pem', :shared_public_key => 'cert_one_pub.pem'} }

    ['cert_one_pvt.pem','cert_one_pub.pem'].each { |f|
      it do
        should contain_file("#{mco_etc}/ssl/#{f}").with({
          'ensure'  => 'present',
          'source'  => "puppet:///modules/mcollective/#{f}",
        })
      end
    }
      
  end

end

