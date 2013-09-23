class CreateDigestDiners < ActiveRecord::Migration
  def self.up
    create_table :digest_diners do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :digest_diners
  end
end
