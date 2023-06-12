# frozen_string_literal: true

# Represents a comment model
class Comment < ApplicationRecord
  belongs_to :photo
  belongs_to :user
end
