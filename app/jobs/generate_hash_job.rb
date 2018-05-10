class GenerateHashJob < ApplicationJob
  queue_as :default

  # I do not want to keep the save out, because then we would need to be waiting
  # on the job to finish in order to update. This is not good encapsulation.
  #
  # however, you don't want to be doing db stuff because then if it doesn't run
  # because of a db thing, then it won't be displayed?
  def perform(nurse)
    nurse.employee_record.gravatar = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest nurse.employee_record.email}"
    nurse.employee_record.save! # this will raise an error this will not affect the client though!
  end
end
