require 'spec_helper'

describe 'Role "roles/role02"' do

  describe 'Test "variable_file_exist"' do
    describe file('/tmp/role02.txt'), :if => os[:family] == 'redhat' do
      it { should be_file }
    end
  end

  describe 'Test "variable_file_contents"' do
    variable_file = <<"EOF"
test_var_role_default: #{property['test_var_role_default']}
test_var_group_all   : #{property['test_var_group_all']}
test_var_group       : #{property['test_var_group']}
test_var_host        : #{property['test_var_host']}
test_var_role        : #{property['test_var_role']}
EOF
    
    describe file('/tmp/role02.txt'), :if => os[:family] == 'redhat' do      
      its(:content) { should match variable_file }
    end
  end

end
