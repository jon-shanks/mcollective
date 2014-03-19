require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'mcollective::facts' do
  let(:facts) { {:made_up_fact => 'test123', :another_fact => 'something_else'} }
  it do 
    should contain_file('/etc/puppetlabs/mcollective/facts.yaml').with({
      'owner' => 'root',
      'group' => 'root',
      'mode'  => '0400',
    })
  end

  it 'should generate the facts file based on defined facts' do
    content = catalogue.resource('file', '/etc/puppetlabs/mcollective/facts.yaml').send(:parameters)[:content]
    content.should_not be_empty 
    content.should match('made_up_fact')
    content.should match('test123')
    content.should match('another_fact')
    content.should match('something_else')
  end

end
