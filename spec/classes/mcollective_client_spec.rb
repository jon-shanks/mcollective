
require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::client' do
  let(:params) { {:mco_etc  => '/etc/puppetlabs/mcollective'} }
  it { should contain_package('pe-mcollective-client') }
  it { should contain_class('mcollective::client::keys') }
  it do
    should contain_file('/etc/puppetlabs/mcollective/client.cfg').with({
      'ensure'  => 'present',
      'require' => 'Package[pe-mcollective-client]'
    })
  end

  context 'when agents defined' do
    let(:params) { {:agents => ['pe-mcollective-git-client', 'pe-mcollective-git-common']} }
    let(:attributes) { {:ensure => 'installed', :require => 'Package[pe-mcollective-client]'} }
    ['pe-mcollective-git-client', 'pe-mcollective-git-common'].each { |pack|
        it do should contain_package(pack).with(attributes) end
    }
  end

  context "check settings for client.cfg template" do
    let(:client_cfg) { '/etc/puppetlabs/mcollective/client.cfg' }
    let(:facts) { {:fqdn  => 'testserver'} }

    context 'when things are default' do
      it 'should have specific default settings' do
        content = catalogue.resource('file', client_cfg).send(:parameters)[:content]
        content.should_not be_empty
        content.should match('topic')
        content.should match('mcollective')
        content.should match('/opt/puppet/libexec/mcollective')
        content.should match('/var/log/pe-mcollective/mcollective.log')
        content.should match('info')
        content.should match('testserver.pem')
        content.should match('localhost')
        content.should match('61613')
        content.should match('/var/opt/lib/pe-puppet/ssl')
        content.should match('nyx-mcollective-servers-public.pem')
      end
    end

    context 'set the activemq servers and other elements' do
      let(:params) { {:log_level => 'debug', :subcollectives => ['collect1', 'collect2'], :client_public_key => 'client-test-pub.pem', :client_private_key => 'client-test-pvt.pem', :shared_public_key => 'this-test-pub.pem', :activemq_servers => ['host1', 'host2'], :mq_port => '99999', :mq_user => 'user123', :mq_pass => 'pass123', :mq_ssl => 'true'} }
      it 'should setup the server with the test params' do
        content = catalogue.resource('file', client_cfg).send(:parameters)[:content]
        content.should_not be_empty
        content.should match('collect1')
        content.should match('collect2')
        content.should match('debug')
        content.should match('client-test-pvt.pem')
        content.should match('client-test-pub.pem')
        content.should match('this-test-pub.pem')
        content.should match('host1')
        content.should match('host2')
        content.should match('99999')
        content.should match('user123')
        content.should match('pass123')
        content.should match('testserver.pem')
      end
    end
  end

end

