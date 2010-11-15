class ChangeRestaurantRoleToPolymorphicOnQuestionRole < ActiveRecord::Migration
  def self.up
    rename_column :question_roles, :restaurant_role_id, :responder_id
    add_column :question_roles, :responder_type, :string

    QuestionRole.all.each do |qr|
      if qr.profile_question.chapter.topic.responder_type == 'restaurant'
        qr.update_attribute(:responder_type, 'RestaurantFeaturePage')
      else
        qr.update_attribute(:responder_type, 'RestaurantRole')
      end
    end
  end

  def self.down
    rename_column :question_roles, :responder_id, :restaurant_role_id
    remove_column :question_roles, :responder_type
  end
end
