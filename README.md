# ansible_spec-test
ansible_specの動作確認用のサンプルplaybook。  
以下を環境に合わせて修正して実行する。  

- inventories/production/hosts：ansible_hostに設定するIPを変更
- inventories/staging/hosts：ansible_hostに設定するIPを変更
- inventories/production/group_vars/all.yml：SSH用のユーザ(ansible_ssh_user)、パスワード(ansible_ssh_pass)を変更
- inventories/staging/group_vars/all.yml：SSH用のユーザ(ansible_ssh_user)、パスワード(ansible_ssh_pass)を変更

## 動作確認済みバージョン
- ansible：7.3.0
- ansible-core：2.14.3
- ansiible_spec：0.3.2
- Serverspec：2.42.2

## ディレクトリ構成
```
ansible
|-- .ansiblespec			# ansiblespec-initで作成される
|-- .rspec				# ansiblespec-initで作成される
|-- Rakefile				# ansiblespec-initで作成される
|-- ansible.cfg
|-- audit				# Serverspecの結果ファイル出力先
|   |-- csv
|   |-- documentation
|   `-- json
|-- formatters				# ServerspecのCustom Formatters置き場
|   `-- serverspec_audit_formatter.rb
|-- inventories
|   |-- production
|   |   |-- group_vars
|   |   |   |-- all.yml
|   |   |   |-- test_group_a.yml
|   |   |   `-- test_group_b.yml
|   |   |-- host_vars
|   |   |   |-- 192.168.10.1.yml
|   |   |   |-- 192.168.10.2.yml
|   |   |   `-- 192.168.10.3.yml
|   |   `-- hosts
|   `-- staging
|       |-- group_vars
|       |   |-- all.yml
|       |   |-- test_group_a.yml
|       |   `-- test_group_b.yml
|       |-- host_vars
|       |   `-- 192.168.20.1.yml
|       `-- hosts
|-- roles
|   |-- role00
|   |   |-- defaults
|   |   |   `-- main.yml
|   |   |-- spec			# specファイル置き場
|   |   |   `-- main_spec.rb
|   |   `-- tasks
|   |       `-- main.yml
|   |-- role01
|   |   |-- defaults
|   |   |   `-- main.yml
|   |   |-- spec
|   |   |   `-- main_spec.rb
|   |   |-- tasks
|   |   |   `-- main.yml
|   |   |-- templates
|   |   |   `-- variable.txt.j2
|   |   `-- vars
|   |       `-- main.yml
|   `-- role02
|       |-- defaults
|       |   `-- main.yml
|       |-- spec
|       |   `-- main_spec.rb
|       |-- tasks
|       |   `-- main.yml
|       |-- templates
|       |   `-- variable.txt.j2
|       `-- vars
|           `-- main.yml
|-- site.yml
|-- spec				# ansiblespec-initで作成される
|   `-- spec_helper.rb			# ansiblespec-initで作成される
|-- test_group_a.yml
`-- test_group_b.yml
```

## 実行例
### Ansible
#### 商用環境に対し実行
$ ansible-playbook -i inventories/production/hosts site.yml  
#### ステージング環境に対し実行
$ ansible-playbook -i inventories/staging/hosts site.yml

### Serverspec(ansible_spec)
#### 商用環境に対し実行
$ rake INVENTORY=inventories/production/hosts VARS_DIRS_PATH=inventories/production LOGIN_PASSWORD="password" IGNORE_FAIL=1 LOG_DIR=audit/documentation/ all
#### ステージング環境に対し実行
$ rake INVENTORY=inventories/staging/hosts VARS_DIRS_PATH=inventories/staging LOGIN_PASSWORD="password" IGNORE_FAIL=1 LOG_DIR=audit/documentation/ all
