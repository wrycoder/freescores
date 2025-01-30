class Part < ApplicationRecord
  belongs_to  :work
  belongs_to  :instrument
end
