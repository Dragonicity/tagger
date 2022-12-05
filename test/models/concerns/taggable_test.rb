require "test_helper"

class TaggableTest < ActiveSupport::TestCase
  class MockTaggable < ApplicationRecord
    self.table_name = "templates"

    include Taggable
    taggable_on :ingredients, :flavors
  end

  setup do
    @account = Account.create!
  end

  test "#tag_type_list=" do
    mock = MockTaggable.new
    mock.apply_ingredients("salt, pasta", @account.id)
    mock.apply_flavors("salty, cosy", @account.id)
    mock.save!

    assert_equal ["salt", "pasta"], mock.ingredients.map(&:name)
    assert_equal ["salt", "pasta"], mock.ingredient_taggings.map(&:tag).map(&:name)
    assert_equal ["salty", "cosy"], mock.flavors.map(&:name)
    assert_equal ["salty", "cosy"], mock.flavor_taggings.map(&:tag).map(&:name)

    mock.save!

    pasta_tag = Tag.i18n.find_by(name: "pasta")
    assert_equal 1, pasta_tag.taggings.count
    pasta_tagging = pasta_tag.taggings.first
    assert_equal mock, pasta_tagging.taggable
    assert_equal "ingredients", pasta_tagging.context
  end

  test "#tag_type_list" do
    mock = MockTaggable.new
    mock.apply_ingredients("salt, pasta", @account.id)
    mock.apply_flavors("salty, cosy", @account.id)

    mock.save!

    Tagging.create!(taggable: mock, tag: Tag.new(name: "pecorino"), context: "ingredients")

    mock.reload

    assert_equal "salt, pasta, pecorino", mock.ingredient_list
  end

  test ".tagged_with" do
    mock_1 = MockTaggable.new
    mock_1.apply_ingredients("salt, pasta", @account.id)
    mock_1.apply_flavors("salty, cosy", @account.id)
    mock_1.save!

    mock_2 = MockTaggable.new
    mock_2.apply_ingredients("pasta, tomato, cosy", @account.id)
    mock_2.apply_flavors("bland", @account.id)
    mock_2.save!

    assert_equal [mock_1, mock_2], MockTaggable.tagged_with("pasta").to_a
    assert_equal [mock_1], MockTaggable.tagged_with("salt").to_a
    assert_equal [mock_1], MockTaggable.tagged_with("salty").to_a
    assert_equal [mock_1, mock_2], MockTaggable.tagged_with("cosy").to_a
    assert_equal [mock_1], MockTaggable.tagged_with("cosy", context: "flavors").to_a
    assert_equal [mock_2], MockTaggable.tagged_with("cosy", context: "ingredients").to_a
  end

  test ".tag_type_counts" do
    mock_1 = MockTaggable.new
    mock_1.apply_ingredients("salt, pasta", @account.id)
    mock_1.apply_flavors("salty, cosy", @account.id)
    mock_1.save!

    mock_2 = MockTaggable.new
    mock_2.apply_ingredients("pasta, tomato, cosy", @account.id)
    mock_2.apply_flavors("bland", @account.id)
    mock_2.save!

    pasta_tag = Tag.i18n.find_by(name: "pasta")
    salt_tag = Tag.i18n.find_by(name: "salt")
    salty_tag = Tag.i18n.find_by(name: "salty")
    cosy_tag = Tag.i18n.find_by(name: "cosy")
    tomato_tag = Tag.i18n.find_by(name: "tomato")
    bland_tag = Tag.i18n.find_by(name: "bland")

    expected_ingredient_counts = { salt_tag.id => 1, pasta_tag.id => 2, tomato_tag.id => 1, cosy_tag.id => 1 }
    assert_equal expected_ingredient_counts, MockTaggable.ingredient_counts

    expected_flavor_counts = { salty_tag.id => 1, cosy_tag.id => 1, bland_tag.id => 1 }
    assert_equal expected_flavor_counts, MockTaggable.flavor_counts
  end
end
