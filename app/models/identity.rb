class Identity < ApplicationRecord
  belongs_to :user
  enum provider: { facebook: 0, google_oauth2: 1 }
  validates_presence_of :provider
  validates_uniqueness_of :uid, scope: :provider
end
