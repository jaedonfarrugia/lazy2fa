# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/utils'

RSpec.describe Utils do
  describe '.load_secrets' do
    it 'loads secrets from the YAML file' do
      expect(Utils.load_secrets).to be_a(Hash)
    end
  end

  describe 'encryption and decryption' do
    let(:data) { 'test data' }
    let(:passphrase) { 'secret' }
    let(:salt) { 'salt' }

    it 'encrypts and decrypts data returning the original data' do
      encrypted_data = Utils.encrypt(data, passphrase, salt)
      decrypted_data = Utils.decrypt(encrypted_data, passphrase, salt)

      expect(decrypted_data).to eq(data)
    end
  end
end
