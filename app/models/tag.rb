class Tag < ApplicationRecord
  extend Mobility
  translates :name, type: :string

  has_many :taggings, inverse_of: :tag
  has_many :articles, through: :taggings
  has_many :templates, through: :taggings

  validates_uniqueness_of :name # scope context

  scope :most_used, ->(limit = 20) { order('taggings_count desc').limit(limit) }
  scope :least_used, ->(limit = 20) { order('taggings_count asc').limit(limit) }

  after_save do |tag|
    begin
     # Tag.create_tag_translations(tag)
    end
  end

  def self.for_context(context)
    joins(:taggings)
      .where("Taggings.context = ?", context)
  end


  def self.create_tag_translations tag
   # require 'google/cloud/translate/v3'
   # ENV["TRANSLATE_CREDENTIALS"] = "config/google_cloud.json"
   # client = ::Google::Cloud::Translate::V3::TranslationService::Client.new

   # tag = Tag.create(name: tag)
   # name_fr = client.translate_text contents: [tag.name], mime_type: "text/plain", source_language_code: "en", target_language_code: "fr", parent: "projects/ritual-moon"
   # tag.update(name_fr: name_fr['translations'].first.translated_text)
   # name_es_co = client.translate_text contents: [tag.name], mime_type: "text/plain", source_language_code: "en", target_language_code: "es", parent: "projects/ritual-moon"
   # tag.update(name_es_co: name_es_co['translations'].first.translated_text)

  end


end
