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

      def self.tagged_with(name, context: nil)
        tag = Tag.i18n.find_by(name: name)
        return self.none unless tag

        taggings_where_query =  { tag_id: tag.id }
        taggings_where_query[:context] = context if context
        joins(:taggings).where(taggings: taggings_where_query)
      end

      self.tag_types.map(&:to_s).each do |tags_type|
        tag_type = tags_type.to_s.singularize
        tagging_type = "#{tag_type}_taggings".to_sym

        class_eval do
          has_many tagging_type, -> { includes(:tag).where(context: tags_type) },
                   as: :taggable,
                   class_name: 'Tagging',
                   dependent: :destroy

          has_many tags_type.to_sym,
                   class_name: 'Tag',
                   through: tagging_type,
                   source: :tag
        end

        define_singleton_method "#{tag_type}_counts" do
          Tagging.where(
            taggable_type: self.to_s,
            context: tags_type
          ).group("taggings.tag_id").count
        end

        define_method "#{tag_type}_list" do
          send(tags_type).map(&:name).join(", ")
        end

        define_method "#{tag_type}_list=" do |comma_separated_tag_names|
          assignment_args = comma_separated_tag_names.split(", ").map do |tag_name|
            Tag.i18n.find_or_initialize_by(name: tag_name)
          end

          send("#{tags_type}=", assignment_args)
        end

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
