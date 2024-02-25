# frozen_string_literal: true

module TestHelpers
  def self.test_secrets
    {
      'service1' => { secret: 'encryptedsecret1' },
      'service2' => { secret: 'encryptedsecret2' },
    }
  end
end
