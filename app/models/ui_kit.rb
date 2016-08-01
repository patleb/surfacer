class UIKit < ActiveType::Object
  attribute :id, :integer, default: proc { SecureRandom.random_number(100) }
  attribute :enum
  attribute :text
  attribute :text_area
  attribute :checkbox, :boolean
  attribute :radio
  attribute :select
  attribute :range, :integer, default: 1
  attribute :number, :integer
  attribute :time, :time
  attribute :date, :date
  attribute :datetime, :datetime
  attribute :toggle, :toggle
end
