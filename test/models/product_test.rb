require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
    product = Product.new(  title: "My Book Title",
                            description: "yyy",
                            image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    assert product.price = 1.00
    assert product.valid?
  end
  
  test "product should be has valid image url" do
    def new_product(image_url)
      Product.new(  title: "My Book Title",
                    description: "yyyyyyyyyyyyyyyyyy",
                    price: 1,
                    image_url: image_url)
    end
    
    valid_url = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Png http://ab.c/x/y/fred.gif}
    invalid_url = %w{fred.doc fred.gif/more fred.jpg.more}
    
    valid_url.each do |url|
      assert new_product(url).valid?, "#{url} should be valid"
    end
    
    invalid_url.each do |url|
      assert new_product(url).invalid?, "#{url} shouldn't be valid"
    end
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(  title: products(:Ruby).title,
                            description: "yyyyyyyyyyyyy",
                            price: 1,
                            image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
  
  test "product is not valid without a unique title - i18n" do
    product = Product.new(  title: products(:Ruby).title,
                            description: "yyyyyyyyyyyyyyy",
                            price: 1,
                            image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
    product.errors[:title]
  end
end
