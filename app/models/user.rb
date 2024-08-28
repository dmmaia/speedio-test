class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :email, type: String
  field :unipile_email_account_id, type: String
  field :unipile_linkedin_account_id, type: String
  field :pin_sent_at, type: Time
  field :last_pin, type: Integer

  validates :email, presence: true, uniqueness: true

end
