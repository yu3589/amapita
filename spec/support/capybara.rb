# Docker環境でシステムスペックを実行するための設定
#
# Docker環境では、Railsアプリが動いているwebコンテナにブラウザがインストールされていないため、
# 別のchromeコンテナでブラウザを起動し、それをリモートで操作してテストを実行する。
# この設定により、webコンテナからchromeコンテナのブラウザを使ってシステムスペックが実行できる。
Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')   # コンテナ内での実行に必要
  options.add_argument('headless')     # 画面表示なしで実行（高速化）
  options.add_argument('disable-gpu')  # GPU無効化（ヘッドレスモードで安定動作）
  options.add_argument('window-size=1680,1050') # ウィンドウサイズ指定（レスポンシブ対応）
  # chromeコンテナ（SELENIUM_DRIVER_URL）に接続してブラウザを操作
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_DRIVER_URL'], capabilities: options)
end
