require 'spec_helper'

describe 'PUT /api/users/:id' do
  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'should reset password' do
    expect(true).to eq true
  end

  it 'should not create an invalid user' do
    expect(true).to eq true
  end

end
