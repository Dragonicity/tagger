module Taggable   
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  class_methods do

    def taggable_on *tag_types
      class_attribute :tag_types
      self.tag_types = tag_types

      self.tag_types.each do |tag_type|

      #http://railscasts.com/episodes/382-tagging
     
      #def self.tagged_with(name)
      #  Tag.find_by_name!(name).articles
      #end

      #def self.tag_counts
      #  Tag.select("tags.*, count(taggings.tag_id) as count").
      #    joins(:taggings).group("taggings.tag_id")
      #end

      #def tag_list
      #  tags.map(&:name).join(", ")
      #end

      #def tag_list=(names)
      #  self.tags = names.split(", ").map do |name|
      #    Tag.where(name: name.strip).first_or_create!
      #end

      #  Requirements
      #
      # 1. Create class/instance methods based on the above to provide basic polymorphic 
      #    tagging functionality including context setting (don't use method_missing).
      #
      # 2. Write Minitest tests for the Template model and concern.
      #
      # 3. Consider how Google translate (if thi sis the best solution) can be integrated to 
      #    generate translations on the fly in French and Spanish. Consider the case of a 
      #    Spanish user entering a Tag in ES_CO locale: what would a general function look 
      #    like that filled in the base EN locale translation (and handle the case where a 
      #    translation is not found)and then provided translations for other locales defined 
      #    for the app. See tag.rb and language_helper.rb.
      end
    end
  end
end