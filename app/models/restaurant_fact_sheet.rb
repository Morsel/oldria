# == Schema Information
# Schema version: 20120217190417
#
# Table name: restaurant_fact_sheets
#
#  id                                :integer         not null, primary key
#  venue                             :string(255)
#  intersection                      :string(255)
#  neighborhood                      :string(255)
#  parking                           :string(255)
#  public_transit                    :string(255)
#  dinner_average_price              :string(255)
#  lunch_average_price               :string(255)
#  brunch_average_price              :string(255)
#  breakfast_average_price           :string(255)
#  children_average_price            :string(255)
#  small_plate_min_price             :string(255)
#  small_plate_max_price             :string(255)
#  large_plate_min_price             :string(255)
#  large_plate_max_price             :string(255)
#  dessert_plate_min_price           :string(255)
#  dessert_plate_max_price           :string(255)
#  wine_by_the_glass_count           :string(255)
#  wine_by_the_glass_min_price       :string(255)
#  wine_by_the_glass_max_price       :string(255)
#  wine_by_the_bottle_count          :string(255)
#  wine_by_the_bottle_min_price      :string(255)
#  wine_by_the_bottle_max_price      :string(255)
#  wine_by_the_bottle_details        :text
#  reservations                      :string(255)
#  cancellation_policy               :text
#  payment_methods                   :string(255)
#  byob_allowed                      :boolean
#  corkage_fee                       :string(255)
#  dress_code                        :string(255)
#  delivery                          :string(255)
#  wheelchair_access                 :string(255)
#  smoking                           :string(255)
#  architect_name                    :string(255)
#  graphic_designer                  :string(255)
#  furniture_designer                :string(255)
#  furniture_manufacturer            :string(255)
#  flooring                          :text
#  millwork                          :text
#  china                             :text
#  kitchen_equipment                 :text
#  lighting                          :text
#  draperies                         :text
#  square_footage                    :string(255)
#  restaurant_id                     :integer
#  parking_and_directions_updated_at :datetime
#  pricing_updated_at                :datetime
#  guest_relations_updated_at        :datetime
#  design_updated_at                 :datetime
#  other_updated_at                  :datetime
#  created_at                        :datetime
#  updated_at                        :datetime
#  days_closed                       :string(255)
#  holidays_closed                   :string(255)
#  concept                           :string(255)
#  entertainment                     :string(255)
#

class RestaurantFactSheet < ActiveRecord::Base
  PARKING_OPTIONS = ["garage", "valet", "street", "lot"]
  RESERVATIONS_OPTIONS = ["accepted", "not accepted", "required", "recommended"]
  SMOKING_OPTIONS = ["not allowed", "outdoors only", "lounge only", "bar only", "hookahs"]
  CONCEPT_OPTIONS = ["bar", "casual", "casual chef-driven", "chef driven", "counter-service",
                     "fast casual", "fast food", "fine dining", "food truck", "formal dining",
                     "neighborhood dining", "quick service", "self-serve", "takeout only", "retail"]
  ENTERTAINMENT_OPTIONS = ["Live Music", "Dancing", "DJ", "Performers", "Piano bar", "Karaoke", "Special appearances"]
  MONEY_FORMAT = /^\d+??(?:\.\d{0,2})?$/
  attr_accessible :venue, :intersection, :neighborhood, :parking, :public_transit, :dinner_average_price, :lunch_average_price, 
   :brunch_average_price, :breakfast_average_price, :children_average_price, :small_plate_min_price, :small_plate_max_price, :large_plate_min_price, :large_plate_max_price, 
   :dessert_plate_min_price, :dessert_plate_max_price, :wine_by_the_glass_count, :wine_by_the_glass_min_price, :wine_by_the_glass_max_price, :wine_by_the_bottle_count, :wine_by_the_bottle_min_price,
   :wine_by_the_bottle_max_price, :wine_by_the_bottle_details, :meals_attributes, :days_closed, :holidays_closed, :reservations, :cancellation_policy, :payment_methods, :byob_allowed,
   :corkage_fee, :dress_code, :delivery, :architect_name, :graphic_designer, :furniture_designer, :furniture_manufacturer, :flooring, :millwork, :china, :kitchen_equipment,
   :lighting, :draperies, :square_footage, :wheelchair_access, :smoking, :concept, :entertainments
  belongs_to :restaurant
  has_many :seating_areas, :dependent => :destroy
  has_many :tasting_menus, :dependent => :destroy
  has_many :meals, :dependent => :destroy

  accepts_nested_attributes_for :seating_areas, :reject_if => lambda{|a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :tasting_menus, :reject_if => lambda{|a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :meals, :reject_if => lambda{|a| a[:name].blank? }, :allow_destroy => true

  before_save :update_timestamps

  validates_inclusion_of :parking, :in => PARKING_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
  validates_inclusion_of :reservations, :in => RESERVATIONS_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
  validates_inclusion_of :smoking, :in => SMOKING_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
  validates_inclusion_of :concept, :in => CONCEPT_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
  validates_presence_of :small_plate_min_price, :message => "can't be blank", :if => proc { |obj| obj.small_plate_max_price? }
  validates_presence_of :small_plate_max_price, :message => "can't be blank", :if => proc { |obj| obj.small_plate_min_price? }
  validates_presence_of :large_plate_min_price, :message => "can't be blank", :if => proc { |obj| obj.large_plate_max_price? }
  validates_presence_of :large_plate_max_price, :message => "can't be blank", :if => proc { |obj| obj.large_plate_min_price? }
  validates_presence_of :dessert_plate_min_price, :message => "can't be blank", :if => proc { |obj| obj.dessert_plate_max_price? }
  validates_presence_of :dessert_plate_max_price, :message => "can't be blank", :if => proc { |obj| obj.dessert_plate_min_price? }
  validates_presence_of :wine_by_the_glass_min_price, :message => "can't be blank", :if => proc { |obj| obj.wine_by_the_glass_max_price? }
  validates_presence_of :wine_by_the_glass_max_price, :message => "can't be blank", :if => proc { |obj| obj.wine_by_the_glass_min_price? }
  validates_presence_of :wine_by_the_bottle_min_price, :message => "can't be blank", :if => proc { |obj| obj.wine_by_the_bottle_max_price? }
  validates_presence_of :wine_by_the_bottle_max_price, :message => "can't be blank", :if => proc { |obj| obj.wine_by_the_bottle_min_price? }

  validates_format_of :dinner_average_price, :with => MONEY_FORMAT
  validates_format_of :lunch_average_price, :with => MONEY_FORMAT
  validates_format_of :brunch_average_price, :with => MONEY_FORMAT
  validates_format_of :breakfast_average_price, :with => MONEY_FORMAT
  validates_format_of :children_average_price, :with => MONEY_FORMAT
  validates_format_of :small_plate_min_price, :with => MONEY_FORMAT
  validates_format_of :small_plate_max_price, :with => MONEY_FORMAT
  validates_format_of :large_plate_min_price, :with => MONEY_FORMAT
  validates_format_of :large_plate_max_price, :with => MONEY_FORMAT
  validates_format_of :dessert_plate_min_price, :with => MONEY_FORMAT
  validates_format_of :dessert_plate_max_price, :with => MONEY_FORMAT
  validates_numericality_of :wine_by_the_glass_count, :integer_only => true, :alllow_nil => true, :allow_blank => true
  validates_format_of :wine_by_the_glass_min_price, :with => MONEY_FORMAT
  validates_format_of :wine_by_the_glass_max_price, :with => MONEY_FORMAT
  validates_numericality_of :wine_by_the_bottle_count, :integer_only => true, :allow_nil => true, :allow_blank => true
  validates_format_of :wine_by_the_bottle_min_price, :with => MONEY_FORMAT
  validates_format_of :wine_by_the_bottle_max_price, :with => MONEY_FORMAT
  validates_numericality_of :square_footage, :integer_only => true, :allow_nil => true, :allow_blank => true

  def design_section_updated_at
    [design_updated_at, seating_areas.collect(&:updated_at)].flatten.max
  end

  def pricing_section_updated_at
    [pricing_updated_at, tasting_menus.collect(&:updated_at)].flatten.max
  end

  def hours_updated_at
    meals.collect(&:updated_at).max
  end

  def info_exists?
    info_exists = false
    [:parking_and_directions, :pricing, :guest_relations, :design, :other].each do |field_set|
      info_exists = send("#{field_set.to_s}_updated_at").present?
      break if info_exists
    end
    info_exists
  end

  def entertainments=(values)
    self.entertainment = Marshal.dump(values.reject {|v| v.blank?})
  end

  def entertainments
    result = []

    begin
      result = Marshal.load(entertainment)
    rescue
    end unless entertainment.blank?

    result
  end

  def activity_name
    "fact sheet"
  end

  private

  def update_timestamps
    updated_time = Time.now
    [:parking_and_directions, :pricing, :guest_relations, :design, :other].each do |field_set|
      changed = FIELD_SETS[field_set].inject(false) do |changed, field|
        changed || self.send("#{field}_changed?")
      end
      send("#{field_set.to_s}_updated_at=", updated_time) if changed
    end
  end

  FIELD_SETS = {
    :parking_and_directions => [:venue, :intersection, :neighborhood, :parking, :public_transit],
    :pricing => [:dinner_average_price, :lunch_average_price, :brunch_average_price, :breakfast_average_price, :children_average_price, :small_plate_min_price, :small_plate_max_price, :large_plate_min_price, :large_plate_max_price, :dessert_plate_min_price, :dessert_plate_max_price, :wine_by_the_glass_count, :wine_by_the_glass_min_price, :wine_by_the_glass_max_price, :wine_by_the_bottle_count, :wine_by_the_bottle_min_price, :wine_by_the_bottle_max_price, :wine_by_the_bottle_details],
    :guest_relations => [:reservations, :cancellation_policy, :payment_methods, :byob_allowed, :corkage_fee, :dress_code, :delivery],
    :design => [:architect_name, :graphic_designer, :furniture_designer, :furniture_manufacturer, :flooring, :millwork, :china, :kitchen_equipment, :lighting, :draperies, :square_footage],
    :other => [:wheelchair_access, :smoking, :concept, :entertainment]
  }
end
