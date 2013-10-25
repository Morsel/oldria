#encoding: utf-8 
class CreateDigestWriters < ActiveRecord::Migration
  def self.up
    create_table :digest_writers do |t|
      t.string :name

      t.timestamps
    end
    DigestWriter.create({:name=>"National Writer"})
    DigestWriter.create({:name=>"Regional Writer"})
    DigestWriter.create({:name=>"Local Writer"})
  end

  def self.down
    drop_table :digest_writers
  end
end
