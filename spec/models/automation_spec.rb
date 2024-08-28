require 'rails_helper'

RSpec.describe Automation, type: :model do
  before(:all) do
    @automation = Automation.create("tipo":"email","message":"hello, world", "programmed_to": "2024-10-01T11:00:00Z")
  end

  it 'checks that a automation can be created' do
    expect(@automation).to be_valid
  end

  it 'checks that a automation can be updated' do
    @automation.update(:message => "linkedin_connection")
    expect(Automation.find(@automation._id)).to eq(@automation)
  end

  it 'checks that a song can be destroyed' do
    @automation.destroy
    expect(Automation.where("tipo":"linkedin_connection", "programmed_to": "2024-10-01T11:00:00Z").first).to be_nil
  end
end
