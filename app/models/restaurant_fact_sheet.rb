class RestaurantFactSheet < ActiveRecord::Base
  PARKING_OPTIONS = ["garage", "valet", "street", "lot"]
  RESERVATIONS_OPTIONS = ["accepted", "not accepted", "required", "recommended"]
  SMOKING_OPTIONS = ["not allowed", "outdoors only", "lounge only", "bar only", "hookahs"]
  MONEY_FORMAT = /^\d+??(?:\.\d{0,2})?$/

  belongs_to :restaurant
  has_many :seating_areas, :dependent => :destroy
  has_many :tasting_menus, :dependent => :destroy

  accepts_nested_attributes_for :seating_areas, :reject_if => lambda{|a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :tasting_menus, :reject_if => lambda{|a| a[:name].blank? }, :allow_destroy => true

  before_save :update_timestamps

  validates_inclusion_of :parking, :in => PARKING_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
  validates_inclusion_of :reservations, :in => RESERVATIONS_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
  validates_inclusion_of :smoking, :in => SMOKING_OPTIONS, :message => "extension %s is not included in the list", :allow_blank => true, :allow_nil => true
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
  validates_numericality_of :wine_by_the_glass_count, :integer_only => true, :allow_nil => true, :allow_blank => true
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
    :other => [:wheelchair_access, :smoking]
  }
end
