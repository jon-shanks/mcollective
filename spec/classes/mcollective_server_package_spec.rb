require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::server::package' do

  it { should contain_package('pe-mcollective').with({'ensure' => 'installed'}) }

  context 'test when agents passed' do
    let(:params) { {:agents => 'pe-mcollective-test'} }

    it do 
      should contain_package('pe-mcollective-test').with({
        'ensure'  => 'installed',
        'require' => 'Package[pe-mcollective]',
      })
    end
  end

end
