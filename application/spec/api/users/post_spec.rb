require 'spec_helper'

describe 'POST /api/users' do

  it 'should create an user' do
    user = build(:user)
    post "api/v1.0/users", user: JSON.parse(Api::ApiEntities::UserParamsEntity.represent(user).to_json) #this sucks, all I wanted was a valid hash. serializable_hash doesn't work out of the box
    created = Api::Models::User.last
    expect(Api::ApiEntities::UserParamsEntity.represent(created).to_json).to eq Api::ApiEntities::UserParamsEntity.represent(user).to_json
  end

  it 'should not create an invalid user' do
    users_count = Api::Models::User.count
    post "api/v1.0/users", user: JSON.parse(Api::ApiEntities::UserParamsEntity.represent(Api::Models::User.new).to_json)
    expect(response_body[:errors]).not_to be_empty
    expect(Api::Models::User.count).to eq users_count
  end

end
