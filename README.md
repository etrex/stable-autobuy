# stable-autobuy

對 unstable-shop 做自動下單的機器人

這個專案要展示的是如何在一個不穩定的商店上完成下單

需要利用冪等性的概念來完成

# 規格

- 確保對指定商品下單完成 1 次後程式停止
- 不考慮搶單效率
- 使用 ruby 的 capybara 做瀏覽器控制
- 自動操作流程
  - 登入系統
  - 開啟指定商品頁
  - 將指定商品加入購物車
  - 結帳
  - 確認訂單完成

# 環境安裝

需要安裝以下軟體

- Chrome
- ChromeDriver
- selenium-webdriver
- Capybara

其中，Chrome 的版本必須與 ChromeDriver 的版本相同。

### 安裝 Chrome

https://www.google.com/intl/zh-TW/chrome/

不解釋

### 安裝 ChromeDriver

透過 brew 安裝：

https://formulae.brew.sh/cask/chromedriver

```bash
brew install --cask chromedriver
```

或直接下載：

https://chromedriver.chromium.org/downloads

並且設定好 path

確認是否安裝完成的方法是輸入以下指令：

```bash
chromedriver -v
```

會出現以下結果：

```
ChromeDriver 91.0.4472.19 (1bf021f248676a0b2ab3ee0561d83a59e424c23e-refs/branch-heads/4472@{#288})
```

### 安裝 selenium-webdriver 與 Capybara

下載本專案後輸入：

```
bundle install
```

# 運行

在 unstable-shop 註冊帳號後，將帳號密碼輸入至 .env 檔案中，設定好想要購買的商品後，執行以下指令：

```
ruby code.rb
```

## 切換行為

將 `code.rb` 中的最後幾行：

```
stable_autobuy
```

改為

```
autobuy
```

將會以不穩定的方式進行自動購買

## 切換瀏覽器

若不想看見瀏覽器的操作流程，可以將上述程式碼當中的：

```ruby
Capybara.default_driver = :selenium_chrome
```

改為

```ruby
Capybara.default_driver = :selenium_chrome_headless
```
