require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

@account = ENV['ACCOUNT']
@password = ENV['PASSWORD']
@product_page = ENV['PRODUCT_PAGE']
@product_name = ENV['PRODUCT_NAME']

Capybara.default_max_wait_time = 1
Capybara.default_driver = :selenium_chrome_headless
Capybara.default_driver = :selenium_chrome


@session = Capybara.current_session

def open(url)
  @session.visit url
end

def find_button(text)
  @session.find_button(text)
rescue
  nil
end

def find_link(text)
  @session.find_link(text)
rescue
  nil
end

def login_button
  find_button('登入')
end

def logout_button
  find_button('登出')
end

def is_login?
  login_button.nil?
end

def login
  login_button.click
  @session.fill_in 'user_email', with: @account
  @session.fill_in 'user_password', with: @password
  @session.find("main input.w-full.px-8.py-3.rounded-md.bg-violet-600.text-gray-50").click
end

def ensure_login
  while is_login? == false
    login
  end
end

def product_in_cart?
  cart_items.map(&:text).any? { |text| text.include? @product_name }
end

def cart_items
  open "https://unstable-shop.fly.dev/cart"
  @session.all(".flex.flex-col.justify-between.w-full.pb-4")
end

def add_product_to_cart
  open @product_page
  find_button("加入購物車")&.click
end

def ensure_product_in_cart
  while product_in_cart? == false
    add_product_to_cart
  end
end

def checkout
  open "https://unstable-shop.fly.dev/cart"
  find_link("前往結帳")&.click
end

open "https://unstable-shop.fly.dev/"
ensure_login
ensure_product_in_cart
checkout
