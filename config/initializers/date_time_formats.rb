# Dateフォーマットの設定
Date::DATE_FORMATS[:default] = "%Y-%m-%d"  # 標準的なISOフォーマット
Date::DATE_FORMATS[:long] = "%Y年%m月%d日"  # 長いフォーマット、例: "2024年03月29日"
Date::DATE_FORMATS[:short] = "%m/%d"  # 短いフォーマット、例: "03/29"

# DateTimeとTimeフォーマットの設定
Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M:%S"  # 標準的なISOフォーマット
Time::DATE_FORMATS[:long] = "%Y年%m月%d日 %H時%M分"  # 長いフォーマット、例: "2024年03月29日 15時45分"
Time::DATE_FORMATS[:short] = "%m/%d %H:%M"  # 短いフォーマット、例: "03/29 15:45"
