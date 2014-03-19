require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::client_certs' do
  let(:title) { 'test_file.pem' }
  let(:params) { {:mco_etc => '/etc/puppetlabs/mcollective'} }
  let(:mco_etc) { '/etc/puppetlabs/mcollective' }

  it do
    should contain_file("#{mco_etc}/ssl/clients/test_file.pem").with({
      'ensure'=>'present',
      'source'=>'puppet:///modules/mcollective/clients/test_file.pem'
    })
  end


end
