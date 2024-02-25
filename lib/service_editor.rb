# frozen_string_literal: true

require 'tty-prompt'
require 'colorize'
require_relative 'utils'

# This module provides functionality to add, rename, and remove services.
# It interacts with the user using TTY prompt and utilizes the Utils module for encryption.
module ServiceEditor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.add_service(secrets, passphrase, salt)
    prompt = TTY::Prompt.new
    name = prompt.ask('Service Name:').downcase

    if secrets.key?(name)
      puts "WARNING: Service with name '#{name}' already exists.".yellow
      overwrite = prompt.select('Do you want to overwrite it?', %w[Yes No])
      return if overwrite == 'No'
    end

    puts 'Please ensure the secret key is the manual entry key (Base32) from your authenticator app.'
    secret = prompt.mask('Secret Key:').gsub(/\s+/, '')

    unless secret.upcase.match?(/\A[A-Z2-7]+\z/)
      puts 'Secret key must be in Base32 format.'.light_red
      return
    end

    encrypted_secret = Utils.encrypt(secret, passphrase, salt)
    secrets[name] = { secret: encrypted_secret }
    Utils.save_secrets(secrets)
    puts "#{name} added.".green
  end

  def self.rename_service(secrets)
    prompt = TTY::Prompt.new
    old_name = prompt.select('Choose a service to rename:', secrets.keys.sort)
    new_name = prompt.ask("Enter the new name for '#{old_name}':").downcase
    if secrets[new_name].nil?
      secrets[new_name] = secrets.delete(old_name)
      Utils.save_secrets(secrets)
      puts "Service '#{old_name}' renamed to '#{new_name}'.".green
    else
      puts "WARNING: Service with name '#{new_name}' already exists.".yellow
      confirm_overwrite = prompt.select(
        'Do you want to overwrite it?', {
          "Yes, overwrite existing entry for #{new_name}" => true,
          'No' => false
        }
      )
      if confirm_overwrite
        secrets[new_name] = secrets.delete(old_name)
        Utils.save_secrets(secrets)
        puts "Service '#{old_name}' renamed to '#{new_name}'.".green
      else
        puts 'Renaming canceled.'.yellow
      end
    end
  end

  def self.remove_service(secrets)
    prompt = TTY::Prompt.new
    name = prompt.select('Choose a service to remove:', secrets.keys.sort)
    confirm = prompt.select("Are you sure you want to remove #{name}?", %w[Yes No])
    if confirm == 'Yes'
      secrets.delete(name)
      Utils.save_secrets(secrets)
      puts "#{name} removed.".yellow
    else
      puts 'Removal canceled.'.yellow
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
