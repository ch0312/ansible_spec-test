require 'rspec/core/formatters/documentation_formatter'
require 'specinfra'
require 'serverspec/version'
require 'serverspec/type/base'
require 'serverspec/type/command'
require 'fileutils'
require 'csv'

class ServerspecAuditFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self, :example_group_started, 
	                           :example_passed, :example_pending, :example_failed

  def initialize(output)
    super
    @seq = 0
  end

  def example_group_started(notification)
    @seq = 0 if @group_level == 0
    super
  end

  def example_passed(notification)
    save_evidence(notification.example)
    super
  end

  def example_pending(notification)
    save_evidence(notification.example)
    super
  end

  def example_failed(notification)
    save_evidence(notification.example, notification.exception)
    super
  end

  # CSVファイルへの出力
  def save_evidence(example, exception=nil)
    #test = example.metadata
    host  = ENV['TARGET_HOST']
    result_status  = example.metadata[:execution_result].status
    location  = example.metadata[:location].to_s
    full_description  = example.metadata[:full_description]

    csv_data = [host, result_status, location, full_description]

    output_file = ENV['LOG_DIR'] + '/' + ENV['LOG_FILE']
    CSV.open(output_file, "a") do |csv|
      csv << csv_data
    end
  end
end
