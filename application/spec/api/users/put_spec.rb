require 'spec_helper'

describe 'PUT /api/users/:id' do

  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'should update an user' do
    authorization_header = login_as(@u1)
    updated_params = {first_name:"Jose", last_name:"Anon", born_on:"1854-12-05 23:23:23"}
    put "api/v1.0/users/#{@u1.id}", {user: updated_params}, authorization_header

    updated = Api::Models::User.find(id:@u1.id)
    updated_born_on = Api::ApiEntities::UserParamsEntity.represent(updated).serializable_hash[:born_on]
    u1_born_on = Api::ApiEntities::UserParamsEntity.represent(@u1).serializable_hash[:born_on]

    expect(last_response.status).to eq 200
    expect(u1_born_on).not_to eq updated_born_on
    expect(updated.first_name).to eq updated_params[:first_name]
    expect(updated.last_name).to eq updated_params[:last_name]
    expect(updated_born_on).to eq updated_params[:born_on]
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
