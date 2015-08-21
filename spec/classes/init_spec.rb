require 'spec_helper'
describe 'windows_utensils' do

  context 'with defaults for all parameters' do
    it { should contain_class('windows_utensils') }
  end
end
