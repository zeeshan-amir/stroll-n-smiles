require "test_helper"

class PlanTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:price_monthly)
  should validate_presence_of(:price_semiannual)
  should validate_presence_of(:price_annual)
  should validate_numericality_of(:price_monthly).is_greater_than_or_equal_to(0)
  should validate_numericality_of(:price_semiannual).is_greater_than_or_equal_to(0)
  should validate_numericality_of(:price_annual).is_greater_than_or_equal_to(0)

  should "order plans by id" do
    assert_equal Plan.by_id.to_sql, Plan.order(id: :ASC).to_sql
  end
end
