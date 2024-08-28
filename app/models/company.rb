class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: String
  field :cnpj, type: String
  field :name, type: String
  field :decisor, type: Object
end