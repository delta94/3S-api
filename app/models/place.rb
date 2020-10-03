class Place < ApplicationRecord
  enum city: {hanoi: 1, hcm: 2, danang: 3, nhatrang: 4, dalat: 5, quangninh: 6, hoian: 7, vungtau: 8}
  enum place_type: {homestay: 1, villa: 2, apartment: 3, penhouse: 4, hostel: 5, motel: 6}

  belongs_to :user
  has_many :coupons, dependent: :destroy
  has_many :overviews, inverse_of: :place, dependent: :destroy
  validates :overviews, length: {minimum: Settings.validations.place.minimum_of_overviews}
  has_many :bookings, dependent: :destroy
  has_many :ratings, inverse_of: :place, dependent: :destroy
  has_many :place_facilities, inverse_of: :place, dependent: :destroy
  has_one :policy, inverse_of: :place, dependent: :destroy
  has_one :rule, inverse_of: :place, dependent: :destroy
  has_one :room, inverse_of: :place, dependent: :destroy
  has_one :schedule_price, inverse_of: :place, dependent: :destroy

  accepts_nested_attributes_for :overviews, allow_destroy: true
  accepts_nested_attributes_for :place_facilities, allow_destroy: true
  accepts_nested_attributes_for :coupons, allow_destroy: true
  accepts_nested_attributes_for :policy, allow_destroy: true
  accepts_nested_attributes_for :rule, allow_destroy: true
  accepts_nested_attributes_for :room, allow_destroy: true
  accepts_nested_attributes_for :schedule_price, allow_destroy: true

  validates :name, presence: true,
    length: {minimum: Settings.validations.place.min_length_of_name,
             maximum: Settings.validations.place.max_length_of_name}
  validates :details, presence: true,
    length: {maximum: Settings.validations.place.max_length_of_details}
  validates :city, presence: true, inclusion: {in: cities.keys}
  validates :place_type, presence: true, inclusion: {in: place_types.keys}
end
