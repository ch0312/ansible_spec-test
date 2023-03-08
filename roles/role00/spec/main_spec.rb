require 'spec_helper'

describe 'Role "roles/role00"' do

  describe 'Test "check_service_enabled"' do
    property['role00_services_list'].each do |service|
      describe service("#{service}"), :if => os[:family] == 'redhat' do
        it { should be_enabled }
      end
    end
  end

end
