class TagTranslationWorker < ApplicationWorker
  def perform(tag_id, original_locale)
    tag = Tag.find_by(id: tag_id)
    return unless tag

    original_locale_name = tag.name_backend.read(original_locale)
    # translation_client = ::Google::Cloud::Translate::V3::TranslationService::Client.new

    Mobility.available_locales.excluding(original_locale).each do |locale|
      next if tag.public_send("name_#{locale}".underscore).present?
      # translation = client.translate_text(
      #   contents: [original_locale_name],
      #   mime_type: "text/plain",
      #   source_language_code: original_locale,
      #   target_language_code: locale,
      #   parent: "projects/ritual-moon"
      # )
      translation = "translated_result"
      tag.name_backend.write(locale, translation)
    end

    tag.save!
  end
end
