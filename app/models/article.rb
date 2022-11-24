class Article < ApplicationRecord
  extend Mobility
  translates :name, type: :string

  has_many :taggings
  has_many :tags, through: :taggings

  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(", ").map do |name|
      Tag.where(name: name_en.strip).first_or_create!
    end
  end
end
