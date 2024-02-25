# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/service_editor'

RSpec.describe ServiceEditor do
  describe '.add_service' do
    let(:secrets) { {} }
    let(:passphrase) { 'passphrase' }
    let(:salt) { 'salt' }
    let(:prompt) { instance_double(TTY::Prompt) }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:ask).with('Service Name:').and_return('service3')
      allow(prompt).to receive(:mask).with('Secret Key:').and_return('MYBASE32SECRETKEY')
      allow(Utils).to receive(:encrypt).and_return('encryptedsecret3')
      allow(Utils).to receive(:save_secrets)
    end

    it 'adds a new service successfully' do
      ServiceEditor.add_service(secrets, passphrase, salt)
      expect(secrets).to have_key('service3')
      expect(Utils).to have_received(:save_secrets).with(secrets)
    end
  end
end
