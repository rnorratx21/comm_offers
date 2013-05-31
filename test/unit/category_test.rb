# == Schema Information
#
# Table name: categories
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  platinum         :boolean
#  category_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
