require 'spec_helper'

describe 'POST /api/users' do
  before :all do
    @u = create :user
  end

  it 'should autheticate an user' do
    post "api/v1.0/users/login", user:{email:@u.email, password:@u.password}
    expect(response_body[:token].to_json).not_to be_empty
  end

  it 'should not autheticate an user with invalid credentials' do
    post "api/v1.0/users/login", user:{email:'not_valid_email', password:'bogus_password'}
    expect(last_response.status).to eq 401
  end

end
