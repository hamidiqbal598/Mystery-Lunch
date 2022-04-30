class MysteryPartner < ApplicationRecord

  belongs_to :employee
  belongs_to :mystery, dependent: :destroy
end
