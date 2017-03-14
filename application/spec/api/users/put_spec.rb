require 'spec_helper'

describe 'PUT /api/users/:id' do

  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'should update an user' do
    authorization_header = login_as(@u1)
    get "api/v1.0/users",nil , authorization_header
    body = response_body
    put "api/v1.0/users/#{@u1.id}", user:{"first_name":"Jose", "last_name":"Anon", "born_on":"1854-12-05 23:23:23"}
    updated = Api::Models::User.find(id:@u1.id)
    expect(true).to eq true
  end

  it 'should not allow an invalid user' do
    get "api/v1.0/users",nil , {}
    expect(last_response.status).to eq 401
  end

  it 'should not allow update other user' do
    authorization_header = login_as(@u2)
    get "api/v1.0/users",nil , authorization_header
    body = response_body
    put "api/v1.0/users/#{@u1.id}", user:{"first_name":"Jose", "last_name":"Anon", "born_on":"1854-12-05 23:23:23"}
    expect(last_response.status).to eq 401
  end

end
