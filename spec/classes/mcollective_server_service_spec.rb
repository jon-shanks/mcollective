require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::server::service' do
  
  context 'when it is defaults' do
    it do
      should contain_service('pe-mcollective').with({
        'ensure'    => 'running',
        'hasstatus' => 'true',
        'enable'    => 'true',
      })
    end
  end

end

