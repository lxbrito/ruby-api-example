require 'spec_helper'
include Mail::Matchers

describe 'perform Password Change Mail Worker' do
  before :all do
    @u1 = create :user
  end

  it 'should send password change email' do
    Sidekiq::Testing.inline! do
      Api::Workers::PasswordChangeMailWorker.perform_async(@u1.id)
      expect(have_sent_email.to(@u1.email)).to be_truthy
    end
  end
end
