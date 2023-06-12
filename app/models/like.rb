# frozen_string_literal: true

# Represents a like model
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :photo
end
