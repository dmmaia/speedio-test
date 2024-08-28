require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = User.create("name":"Joe Doe 1234","email":"joe@email.com")
  end

  it 'checks that a user can be created' do
    expect(@user).to be_valid
  end

  it 'checks that a user can be read' do
    expect(User.find_by("email":"joe@email.com")).to eq(@user)
  end

  it 'checks that a user can be updated' do
    @user.update(:name => "Joe Who")
    expect(User.find_by("name":"Joe Who")).to eq(@user)
  end

  it 'checks that a song can be destroyed' do
    @user.destroy
    expect(User.where(email: "joe@email.com").first).to be_nil
  end

end
