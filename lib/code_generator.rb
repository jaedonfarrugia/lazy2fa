# frozen_string_literal: true

require 'rotp'
require 'colorize'
require 'clipboard'
require_relative 'utils'
require_relative 'service_list'

# This module generates OTP codes for specified services using ROTP library.
# It utilizes the Utils module to decrypt the secret key before generating the code.
module CodeGenerator
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.generate_code(service_name, secrets, passphrase, salt)
    secret_info = secrets[service_name.downcase]
    if secret_info.nil?
      puts "Error: Service '#{service_name}' not found.".light_red
      ServiceList.list_services(secrets)
      exit 1
    end

    secret = Utils.decrypt(secret_info[:secret], passphrase, salt)
    if secret.nil?
      puts "Error: Failed to decrypt secret for service '#{service_name}'.".light_red
      exit 1
    end

    totp = ROTP::TOTP.new(secret)
    otp = totp.now
    remaining_time = 30 - (Time.now.to_i % 30)
    puts "Your OTP for #{service_name}: " + otp.green + ". Expires in #{remaining_time} seconds."
    Clipboard.copy(otp)
    puts 'OTP copied to clipboard.'.green
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
