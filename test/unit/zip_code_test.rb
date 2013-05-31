# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer         not null, primary key
#  zip_code   :string(255)
#  city       :string(255)
#  state      :string(255)
#  lat        :float
#  lng        :float
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
