module DecomojisHelper
  def pagy_info_with_comma(pagy)
    total = number_with_delimiter(pagy.count)
    from = number_with_delimiter(pagy.from)
    to = number_with_delimiter(pagy.to)

    "Displaying items #{from} - #{to} of #{total}"
  end
end
