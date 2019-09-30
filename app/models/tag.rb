class Tag < ApplicationRecord
  belongs_to :page

  enum name: [:h1, :h2, :h3]
end
