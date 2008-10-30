class CreateRecommendationAnswers < ActiveRecord::Migration
  def self.up
    create_table :recommendation_answers do |t|
      t.belongs_to :recommendation
      t.belongs_to :recommendation_answer_definition
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendation_answers
  end
end
