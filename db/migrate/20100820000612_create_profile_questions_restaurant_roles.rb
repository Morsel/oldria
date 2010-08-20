class CreateProfileQuestionsRestaurantRoles < ActiveRecord::Migration
  def self.up
    create_table :profile_questions_restaurant_roles, :id => false do |t|
      t.column :profile_question_id, :integer
      t.column :restaurant_role_id, :integer
    end
  end

  def self.down
    drop_table :profile_questions_restaurant_roles
  end
end
