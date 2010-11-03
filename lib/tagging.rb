class Tagging < ActiveRecord::Base

  validates_presence_of :network_id, :tag_id, :taggable_id, :taggable_type

  belongs_to :network
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  after_destroy :destroy_unused_tags
  
  def destroy_unused_tags
    if Tag.destroy_unused and tag.taggings.count.zero?
      tag.destroy
    end
  end
end
