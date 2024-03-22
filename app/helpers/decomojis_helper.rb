module DecomojisHelper
  def pagy_info_with_comma(pagy)
    total = number_with_delimiter(pagy.count)
    from = number_with_delimiter(pagy.from)
    to = number_with_delimiter(pagy.to)

    "#{total} 件中 #{from} から #{to} 件目を表示中"
  end
end
