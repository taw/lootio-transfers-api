class Token < ApplicationRecord
  belongs_to :user
  # Token key should be some kind of UUID, not serial ID
  # Also needs expiration dates etc.
end
