require 'spec_helper'
include Mail::Matchers

describe 'perform Registration Mail Worker' do
  before :all do
    @u1 = create :user
  end

  it 'should send registration email' do
    Sidekiq::Testing.inline! do
      Api::Workers::RegistrationMailWorker.perform_async(@u1.id)
      expect(have_sent_email.to(@u1.email)).to be_truthy
    end
  end
end
