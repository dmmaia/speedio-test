class Automation
  include Mongoid::Document
  include Mongoid::Timestamps
  field :company_id, type: String
  field :tipo, type: String
  field :message, type: String
  field :programmed_to, type: Time
  field :sent_at, type: Time
end
