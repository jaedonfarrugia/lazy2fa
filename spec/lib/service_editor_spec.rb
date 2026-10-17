# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/service_editor'

RSpec.describe ServiceEditor do
  describe '.clean_name' do
    it 'removes an Option+Left escape sequence' do
      expect(ServiceEditor.clean_name("microsoft\ebjaedon")).to eq('microsoftjaedon')
    end

    it 'removes ANSI arrow-key sequences and other control characters' do
      expect(ServiceEditor.clean_name("Git\e[DHub\t")).to eq('github')
    end

    it 'leaves a normal name unchanged apart from case and whitespace' do
      expect(ServiceEditor.clean_name(' Nova_Microsoft ')).to eq('nova_microsoft')
    end
  end

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

    it 'strips escape characters from the service name' do
      allow(prompt).to receive(:ask).with('Service Name:').and_return("microsoft\ebjaedon")
      ServiceEditor.add_service(secrets, passphrase, salt)
      expect(secrets.keys).to eq(['microsoftjaedon'])
    end
  end

  describe '.rename_service' do
    let(:secrets) { { "microsoft\ebjaedon" => { secret: 'encryptedsecret' } } }
    let(:prompt) { instance_double(TTY::Prompt) }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:select).and_return("microsoft\ebjaedon")
      allow(prompt).to receive(:ask).and_return("microsoft\e[D_jaedon")
      allow(Utils).to receive(:save_secrets)
    end

    it 'strips escape characters from the new name' do
      ServiceEditor.rename_service(secrets)
      expect(secrets).to eq('microsoft_jaedon' => { secret: 'encryptedsecret' })
    end
  end
end
