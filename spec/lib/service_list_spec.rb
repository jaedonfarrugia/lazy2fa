# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/service_list'

RSpec.describe ServiceList do
  describe '.list_services' do
    let(:secrets) { TestHelpers.test_secrets }

    it 'lists available services' do
      expect { ServiceList.list_services(secrets) }
        .to output(/Available Services:\n- service1\n- service2/).to_stdout
    end

    it 'indicates when no services are available' do
      expect { ServiceList.list_services({}) }
        .to output(/No services found/).to_stdout
    end
  end
end
