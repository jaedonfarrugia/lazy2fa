# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/code_generator'

# rubocop:disable Metrics/BlockLength
RSpec.describe CodeGenerator do
  describe '.generate_code' do
    let(:secrets) { { 'service1' => { secret: 'encryptedsecret1' } } }
    let(:passphrase) { 'testpass' }
    let(:salt) { 'testsalt' }
    let(:decrypted_secret) { 'decryptedsecret1' }

    before do
      allow(Utils).to receive(:decrypt).and_return(decrypted_secret)
      allow(ROTP::TOTP).to receive(:new).with(decrypted_secret).and_return(instance_double(ROTP::TOTP, now: '123456'))
      allow(Clipboard).to receive(:copy)
    end

    context 'when service is found and secret is successfully decrypted' do
      it 'generates and outputs an OTP code' do
        expect do
          CodeGenerator.generate_code('service1', secrets, passphrase, salt)
        end.to output(/123456/).to_stdout
        expect(Clipboard).to have_received(:copy).with('123456')
      end
    end

    context 'when service is not found' do
      it 'outputs an error message' do
        expect do
          CodeGenerator.generate_code('unknown_service', secrets, passphrase, salt)
        end.to output(/Error: Service 'unknown_service' not found/).to_stdout.and raise_error(SystemExit)
      end
    end

    context 'when secret decryption fails' do
      let(:decrypted_secret) { nil } # Simulate decryption failure

      it 'outputs an error message' do
        expect do
          CodeGenerator.generate_code('service1', secrets, passphrase, salt)
        end.to output(/Error: Failed to decrypt secret for service 'service1'/).to_stdout.and raise_error(SystemExit)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
