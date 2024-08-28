require 'rails_helper'

RSpec.describe Company, type: :model do
  before(:all) do
    @company = Company.create("name":"Joe LTDA","cnpj":"36.109.176/0001-23")
  end

  it 'checks that a company can be created' do
    expect(@company).to be_valid
  end

  it 'checks that a company can be read' do
    expect(Company.find_by("cnpj":"36.109.176/0001-23")).to eq(@company)
  end

  it 'checks that a company can be updated' do
    @company.update(:name => "Joe LTDA2")
    expect(Company.find_by("name":"Joe LTDA2")).to eq(@company)
  end

  it 'checks that a song can be destroyed' do
    @company.destroy
    expect(Company.where(cnpj: "36.109.176/0001-23").first).to be_nil
  end
end
