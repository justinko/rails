# frozen_string_literal: true

require "cases/helper"

module ActiveRecord
  class TableMetadataTest < ActiveSupport::TestCase
    test "#associated_table creates the right type caster for joined table with different association name" do
      base_table_metadata = TableMetadata.new(Product, Arel::Table.new("products"))

      associated_table_metadata = base_table_metadata.associated_table("product_types")

      assert_equal NicknameType, associated_table_metadata.arel_table.type_for_attribute(:nickname).class
    end

    class NicknameType < ActiveRecord::Type::String; end

    class Product < ActiveRecord::Base
      self.table_name = "products"
      has_many :types, class_name: "ProductType"
    end

    class ProductType < ActiveRecord::Base
      self.table_name = "product_types"
      attribute :nickname, NicknameType.new
    end
  end
end
