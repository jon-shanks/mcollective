require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::server' do
  let(:params) { {:mco_etc  => '/etc/puppetlabs/mcollective'} }
  it { should contain_class('mcollective::server::package') }
  it { should contain_class('mcollective::server::service') }
  it { should contain_class('mcollective::server::keys') }
  it { should contain_class('mcollective::facts') }
  it do
    should contain_file('/etc/puppetlabs/mcollective/server.cfg').with({
      'ensure'  => 'present',
    })
  end


  context "check settings for server.cfg template" do
    let(:server_cfg) { '/etc/puppetlabs/mcollective/server.cfg' }
    let(:facts) { {:fqdn  => 'testserver'} }
 
    context 'when things are default' do
      it 'should have specific default settings' do
        content = catalogue.resource('file', server_cfg).send(:parameters)[:content]
        content.should_not be_empty
        content.should match('mcollective')
        content.should match('/opt/puppet/libexec/mcollective')
        content.should match('/var/log/pe-mcollective')
        content.should match('info')
        content.should match('testserver')
        content.should match('localhost')
        content.should match('61613')
        content.should match('/var/opt/lib/pe-puppet/ssl')
        content.should match('nyx-mcollective-servers-private.pem')
        content.should match('nyx-mcollective-servers-public.pem')
      end
    end

    context 'set the activemq servers and other elements' do
      let(:params) { {:log_level => 'debug', :subcollectives => ['collect1', 'collect2'], :shared_private_key => 'this-test-pvt.pem', :shared_public_key => 'this-test-pub.pem', :activemq_servers => ['host1', 'host2'], :mq_port => '99999', :mq_user => 'user123', :mq_pass => 'pass123', :mq_ssl => 'true'} }
      it 'should setup the server with the test params' do
        content = catalogue.resource('file', server_cfg).send(:parameters)[:content]
        content.should_not be_empty
        content.should match('collect1')
        content.should match('collect2')
        content.should match('debug')
        content.should match('this-test-pvt.pem')
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

