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
Capybara.match = :first

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

def is_purchased?
  open "https://unstable-shop.fly.dev/orders"
  @session.all(".px-3.py-1.font-semibold.rounded-md.bg-violet-600.text-gray-50 a").last&.click
  @session.find(".text-lg.font-semibold.leading-snug")&.text == @product_name
end

def ensure_buy_once
  while is_purchased? == false
    # 若未將商品加入購物車，將商品加入購物車
    ensure_product_in_cart

    # 結帳
    checkout
  end
end


def stable_autobuy
  # 開啟首頁
  open "https://unstable-shop.fly.dev/"

  # 若未登入，執行登入
  ensure_login

  # 若尚未完成購買，執行購買
  ensure_buy_once
end

def autobuy
  # 開啟首頁
  open "https://unstable-shop.fly.dev/"

  # 執行登入
  login

  # 將商品加入購物車
  add_product_to_cart

  # 結帳
  checkout
end

stable_autobuy

byebug

a = 1