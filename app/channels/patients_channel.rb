class PatientsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "patients"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
