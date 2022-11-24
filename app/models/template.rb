class Template < ApplicationRecord
  include Taggable
  taggable_on :tags, :reversed_meanings, :symbols

end