# frozen_string_literal: true

require 'optparse'
require_relative '../lib/code_generator'
require_relative '../lib/service_list'
require_relative '../lib/service_editor'
require_relative '../lib/utils'

prompt = TTY::Prompt.new
secrets = Utils.load_secrets
passphrase = ENV['LAZY_2FA_PASSPHRASE']
salt = ENV['LAZY_2FA_SALT']

if passphrase.nil? || salt.nil?
  puts 'Error: Please set the LAZY_2FA_PASSPHRASE and LAZY_2FA_SALT environment variables.'.light_red
  exit 1
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby app.rb [options]'

  opts.on('-g SERVICE_NAME', '--generate=SERVICE_NAME', 'Generate OTP for the specified service') do |service_name|
    options[:generate] = service_name
  end

  opts.on('-l', '--list', 'List all available services') do
    options[:list] = true
  end

  opts.on('-h', '--help', 'Print this help message') do
    puts opts
    exit
  end
end.parse!

if options[:generate]
  CodeGenerator.generate_code(options[:generate], secrets, passphrase, salt)
  exit
elsif options[:list]
  ServiceList.list_services(secrets)
  exit
end

loop do
  action_list = ['Generate Code', 'List Services', 'Add Service', 'Rename Service', 'Remove Service', 'Exit']
  if secrets.empty?
    action_list.delete('Generate Code')
    action_list.delete('Rename Service')
    action_list.delete('Remove Service')
  end
  action = prompt.select('What would you like to do?', action_list)

  case action
  when 'Generate Code'
    service = prompt.select('Choose a service', secrets.keys.sort)
    CodeGenerator.generate_code(service, secrets, passphrase, salt)
  when 'List Services'
    ServiceList.list_services(secrets)
  when 'Add Service'
    ServiceEditor.add_service(secrets, passphrase, salt)
  when 'Rename Service'
    ServiceEditor.rename_service(secrets)
  when 'Remove Service'
    ServiceEditor.remove_service(secrets)
  when 'Exit'
    break
  end
end
