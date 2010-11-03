class Tag < ActiveRecord::Base
  acts_as_network_scoped :ns_id => false

  has_many    :taggings, :dependent => :destroy

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :network_id

  cattr_accessor :destroy_unused
  self.destroy_unused = false

  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end

  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end

  def to_s
    name
  end

  def count
    read_attribute(:count).to_i
  end

  def member_permitted_to?(action, member)
    member.has_role?(:admin, network.root_space)
  end
end
