class Tagging < ApplicationRecord
  DEFAULT_CONTEXT = 'tags'

  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  belongs_to :tagger,   polymorphic: true, optional: true

  validates_presence_of :context
  validates_presence_of :tag_id

  validates_uniqueness_of :tag_id, scope: %i[taggable_type taggable_id context tagger_id tagger_type]

  scope :by_contexts, ->(contexts) { where(context: (contexts || DEFAULT_CONTEXT)) }
  scope :by_context, ->(context = DEFAULT_CONTEXT) { by_contexts(context.to_s) }

  after_destroy :remove_unused_tags

  private

  #def remove_unused_tags
  #  tag.destroy if tag.reload.taggings.none?
  #end


end
