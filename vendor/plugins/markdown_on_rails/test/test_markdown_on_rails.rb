require 'rubygems'
require 'lib/markdown_on_rails'

class MarkdownOnRailsTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_not_nil
    assert_not_nil @customers
  end
      
  def test_record_data
    assert_equal 'Business One', @customers[0].business_name
    assert_equal 'Business Two', @customers[1].business_name
    assert_equal 'Business Three', @customers[2].business_name
  end
  
  def test_csv_header
    assert_equal ['business_name'], Customer.csv_header
    assert_equal ['id', 'business_name', 'contact_name'], OtherCustomer.csv_header
  end
  
  def test_record_to_csv
    assert_equal %q(Business Three), Customer.find(3).to_csv
    assert_equal %q(Business One), Customer.find(1).to_csv
    
    assert_equal %q(3,Business Three,frank), OtherCustomer.find(3).to_csv
    assert_equal %q(1,Business One,fred), OtherCustomer.find(1).to_csv
  end  
  
end