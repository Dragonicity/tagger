module LanguageHelper
  LANGUAGES = {
    'es-co': "Spanish",
    en: "English",
    fr: "French"
  }

  def language_options
    LANGUAGES.slice(*I18n.available_locales).invert.to_a
  end

  def all_locales
    I18n.available_locales
  end
end
