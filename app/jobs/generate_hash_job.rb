class GenerateHashJob < ApplicationJob
  queue_as :default

  def perform(nurse)
    nurse.employee_record.gravatar = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest nurse.employee_record.email}"
    nurse.employee_record.save! # this will raise an error but will not affect the client
  end
end
