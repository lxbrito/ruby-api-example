require 'spec_helper'

describe 'GET /api/users' do
  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'should pull all users' do
    authorization_header = login_as(@u1)
    get "api/v1.0/users",nil , authorization_header
    body = response_body
    emails = body.map{ |x| x[:email] }
    expect(emails).to include @u1.email
    expect(emails).to include @u2.email
  end

  it 'should not authorize' do
    get "api/v1.0/users",nil , {}
    expect(last_response.status).to eq 401
  end
end
