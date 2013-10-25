#encoding: utf-8 
class TransferRestaurantBtlToNewModels < ActiveRecord::Migration
  def self.up
    # Restaurant topics were created in an earlier migration
    RestaurantTopic.all.each.map(&:profile_questions).flatten.each do |question|
      new_question = RestaurantQuestion.create!(:title => question.title,
                                               :position => question.position,
                                               :chapter_id => question.chapter_id,
                                               :pages_description => question.roles_description)
      puts "Created #{new_question.title}"

      if question.profile_answers.present?
        question.profile_answers.each { |a| RestaurantAnswer.create!(:answer => a.answer,
                                                                     :restaurant_question_id => new_question.id,
                                                                     :restaurant_id => a.user_id) }
      end
      puts "Migrated #{question.profile_answers.count} answers for #{new_question.title}"

      if question.question_roles.present?
        question.question_roles.each { |r| QuestionPage.create!(:restaurant_question_id => new_question.id,
                                                                :restaurant_feature_page_id => r.restaurant_role_id )}
      end
      puts "Migrated #{question.question_roles.count} page associations for #{new_question.title}"
    end
  end

  def self.down
    # Do nothing, we're not deleting the old restaurant btl content yet
  end
end
