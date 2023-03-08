require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
require 'ansible_spec'

properties = AnsibleSpec.get_properties
# {"name"=>"Ansible-Sample-TDD", "hosts"=>["192.168.0.103","192.168.0.103"], "user"=>"root", "roles"=>["nginx", "mariadb"]}
# {"name"=>"Ansible-Sample-TDD", "hosts"=>[{"name" => "192.168.0.103:22","uri"=>"192.168.0.103","port"=>22, "private_key"=> "~/.ssh/id_rsa"}], "user"=>"root", "roles"=>["nginx", "mariadb"]}
cfg = AnsibleSpec::AnsibleCfg.new

desc "Run serverspec to all test"
task :all => "serverspec:all"

namespace :serverspec do
  properties = properties.compact.reject{|e| e["hosts"].length == 0}
  task :all => properties.map {|v| 'serverspec:' + v["name"] }
  properties.each_with_index.map do |property, index|
    property["hosts"].each do |host|
      desc "Run serverspec for #{property["name"]}"
      RSpec::Core::RakeTask.new(property["name"].to_sym) do |t|
        puts "Run serverspec for #{property["name"]} to #{host}"
        ENV['TARGET_HOSTS'] = host["hosts"]
        ENV['TARGET_HOST'] = host["uri"]
        ENV['TARGET_PORT'] = host["port"].to_s
        ENV['TARGET_GROUP_INDEX'] = index.to_s
        ENV['TARGET_PRIVATE_KEY'] = host["private_key"]
        unless host["user"].nil?
          ENV['TARGET_USER'] = host["user"]
        else
          ENV['TARGET_USER'] = property["user"]
        end
        ENV['TARGET_PASSWORD'] = host["pass"]
        ENV['TARGET_CONNECTION'] = host["connection"]

        roles = property["roles"]
        for role in property["roles"]
          for rolepath in cfg.roles_path
            deps = AnsibleSpec.load_dependencies(role, rolepath)
            if deps != []
              roles += deps
              break
            end
          end
        end
	# 実行ホスト名、実行ロールを表示する
        puts "#####################################################################"
        puts "  Target host : #{host["name"]}"
        puts "  Target role : {#{cfg.roles_path.join(',')}}/{#{roles.join(',')}}"
        puts "##################################################3##################"
        t.pattern = '{' + cfg.roles_path.join(',') + '}/{' + roles.join(',') + '}/spec/*_spec.rb'
        # 実行結果をファイル出力する
        if ENV['LOG_DIR']
　　　　　# 使いたいフォーマットのコメントアウトを外すこと
	  # Documentation
	  t.rspec_opts = "--format documentation -o #{ENV['LOG_DIR']}/$(date +%Y%m%d-%H%M%S)-#{ENV['TARGET_HOST']}.log"
          # JSON
	  #t.rspec_opts = "--format json -o #{ENV['LOG_DIR']}/$(date +%Y%m%d-%H%M%S)-#{ENV['TARGET_HOST']}.json"
          # CSV
   	  #t.rspec_opts = "--format ServerspecAuditFormatter --require ./formatters/serverspec_audit_formatter.rb"
	end
	# 環境変数IGNORE_FAILが1の場合、途中でfailしてもテストを続ける
        if ENV['IGNORE_FAIL'] == "1"
	  t.fail_on_error = false
        end
      end
    end
  end
end
