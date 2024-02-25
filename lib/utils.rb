# frozen_string_literal: true

require 'yaml'
require 'openssl'
require 'base64'
require 'fileutils'

# This module provides utilities for loading and saving secrets,
# as well as encrypting and decrypting data for secure storage and retrieval.
module Utils
  def self.load_secrets
    file_path = File.expand_path('../data/secrets.yml', __dir__)
    FileUtils.mkdir_p(File.dirname(file_path)) unless File.exist?(file_path)
    File.write(file_path, {}.to_yaml) unless File.exist?(file_path)
    YAML.load_file(file_path)
  end

  def self.save_secrets(secrets)
    file_path = File.expand_path('../data/secrets.yml', __dir__)
    File.open(file_path, 'w') { |file| file.write(secrets.to_yaml) }
  end

  def self.generate_key_iv(passphrase, salt, iterations: 100_000, key_length: 32, iv_length: 16)
    pbkdf2 = OpenSSL::KDF.pbkdf2_hmac(
      passphrase,
      salt: salt,
      iterations: iterations,
      length: key_length + iv_length,
      hash: 'sha256'
    )
    key = pbkdf2[0, key_length]
    iv = pbkdf2[key_length, iv_length]
    [key, iv]
  end

  def self.encrypt(data, passphrase, salt)
    key, iv = generate_key_iv(passphrase, salt)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv
    encrypted = cipher.update(data) + cipher.final
    Base64.strict_encode64(encrypted)
  rescue OpenSSL::Cipher::CipherError => e
    raise StandardError, "Encryption failed: #{e.message}"
  end

  def self.decrypt(encrypted_data, passphrase, salt)
    key, iv = generate_key_iv(passphrase, salt)
    decipher = OpenSSL::Cipher.new('AES-256-CBC')
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
    decipher.update(Base64.strict_decode64(encrypted_data)) + decipher.final
  rescue OpenSSL::Cipher::CipherError => e
    raise StandardError, "Decryption failed: #{e.message}"
  end
end
