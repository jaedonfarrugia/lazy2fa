# frozen_string_literal: true

require 'colorize'

# This module provides functionality to list all available services.
# It prints out the names of the services stored in the secrets.
module ServiceList
  def self.list_services(secrets)
    if secrets.empty?
      puts 'No services found.'.light_red
    else
      puts 'Available Services:'
      secrets.keys.sort.each { |service_name| puts "- #{service_name}" }
    end
  end
end
