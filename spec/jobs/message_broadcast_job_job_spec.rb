require 'rails_helper'

RSpec.describe MessageBroadcastJob, type: :job do
  describe "#perform_later" do
    it "broadcast message to recipient" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        MessageBroadcastJob.perform_later('messages')
      }.to have_enqueued_job
    end
  end
end
