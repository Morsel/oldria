class QuickReply < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :message_id, :string
  column :message_type, :string
  column :reply_text, :text
  column :user_id, :integer

  validates_length_of :reply_text, :maximum => 500

  belongs_to :message, :polymorphic => true
  belongs_to :user
  has_many :restaurants

  def save
    # This is where the action is!
    return false unless valid?
    debugging_info
    true
  end


  def debugging_info
    Rails.logger.info <<-EOT

    restaurant_ids = #{restaurant_ids}
    user = #{user.name}
    message = #{message_type} #{message_id}

    EOT
  end

end
