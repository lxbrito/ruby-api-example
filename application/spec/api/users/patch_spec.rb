require 'spec_helper'

describe 'PATCH /api/users/:id' do
  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'should reset password' do
    authorization_header = login_as(@u1)
    pass = '12345678'
    patch "api/v1.0/users/#{@u1.id}/reset_password", {user:{new_password:pass, confirm_password:pass}}, authorization_header
    updated = Api::Models::User.find(id: @u1.id)
    expect(response_body).to eq({message:"password successfully changed"})
    expect(@u1.password).not_to eq pass
    expect(updated.password).to eq pass
    expect(Api::Workers::PasswordChangeMailWorker.jobs.size).to eq 1 #horrible test
  end

  it 'should reset password only when they match' do
    authorization_header = login_as(@u1)
    patch "api/v1.0/users/#{@u1.id}/reset_password", {user:{new_password:'12345678', confirm_password:'123456789!'}}, authorization_header
    expect(response_body).to eq({:errors => {:password_match=>["must match confirmation"]}})
  end

  it 'should not allow an invalid user' do
    patch "api/v1.0/users/#{@u1.id}/reset_password", nil , {}
    expect(last_response.status).to eq 401
  end

  it 'should not allow update other user' do
    authorization_header = login_as(@u2)
    patch "api/v1.0/users/#{@u1.id}/reset_password", {user:{new_password:'12345678', confirm_password:'12345678'}}, authorization_header
    expect(last_response.status).to eq 401
  end

end
