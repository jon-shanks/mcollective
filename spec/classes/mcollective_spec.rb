require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective' do
  context 'when server is false and client false' do
    let(:params) { {:server => false, :client => false} }

    it { should_not contain_class('mcollective::server') }
    it { should_not contain_class('mcollective::client') }

  end

  context 'when server is true and client false' do
    let(:params) { {:server => true, :client  => false} }

    it { should contain_class('mcollective::server') }
    it { should_not contain_class('mcollective::client') }

  end

  context 'when server is false and client true' do
    let(:params) { {:server => false, :client  => true} }

    it { should_not contain_class('mcollective::server') }
    it { should contain_class('mcollective::client') }

  end

  context 'when server is true and client true' do
    let(:params) { {:server => true, :client  => true} }

    it { should contain_class('mcollective::server') }
    it { should contain_class('mcollective::client') }

  end


end
