class CreateQueries < ActiveRecord::Migration[6.1]
  def change
    create_table :queries do |t|
      t.text :content
      t.text :sentiment_language
      t.text :sentiment_score
      t.text :sentiment_magnitude
      t.text :sentiment_raw
      t.text :entities_raw
      t.text :syntax_raw
      t.timestamps
    end
  end
end
