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

# capybara 輔助方法
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

def find(selector)
  @session.find(selector)
rescue
  nil
end

# 基本爬蟲功能
def open(url)
  @session.visit url
end

def login
  find_button('登入').click
  @session.fill_in 'user_email', with: @account
  @session.fill_in 'user_password', with: @password
  find("main input.w-full.px-8.py-3.rounded-md.bg-violet-600.text-gray-50").click
end

def add_product_to_cart
  open @product_page
  find_button("加入購物車")&.click
end

def checkout
  open "https://unstable-shop.fly.dev/cart"
  find_link("前往結帳")&.click
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






# 穩定版本爬蟲功能
def safe_click(node)
  node&.click
rescue
end

def safe_fill_in(node_name, value)
  @session.fill_in node_name, with: value
rescue
end

def ensure_open(url)
  open url
rescue
  ensure_open(url)
end

def is_login?
  find_button('登出') != nil
end

def ensure_login
  ensure_open "https://unstable-shop.fly.dev/"
  while is_login? == false
    ensure_open "https://unstable-shop.fly.dev/"
    safe_click find_button('登入')
    safe_fill_in 'user_email', @account
    safe_fill_in 'user_password', @password
    safe_click find("main input.w-full.px-8.py-3.rounded-md.bg-violet-600.text-gray-50")
  end
end

def product_in_cart?
  cart_items.map(&:text).any? { |text| text.include? @product_name }
end

def cart_items
  ensure_open "https://unstable-shop.fly.dev/cart"
  @session.all(".flex.flex-col.justify-between.w-full.pb-4")
end

def ensure_product_in_cart
  while product_in_cart? == false
    ensure_open @product_page
    safe_click find_button("加入購物車")
  end
end

def is_purchased?
  ensure_open "https://unstable-shop.fly.dev/orders"
  safe_click @session.all(".px-3.py-1.font-semibold.rounded-md.bg-violet-600.text-gray-50 a").last
  find(".text-lg.font-semibold.leading-snug")&.text == @product_name
end

def ensure_checkout
  ensure_open "https://unstable-shop.fly.dev/cart"
  safe_click find_link("前往結帳")
end

def stable_autobuy
  # 若未登入，執行登入
  ensure_login

  # 若尚未完成購買，執行購買
  while is_purchased? == false
    # 若未將商品加入購物車，將商品加入購物車
    ensure_product_in_cart

    # 確保結帳
    ensure_checkout
  end
end

stable_autobuy

byebug

a = 1