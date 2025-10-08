class RakutenApiService
  def search(keyword)
    return nil if keyword.blank?

    Rails.logger.info "Rakuten API: Searching for '#{keyword}'"

    items = RakutenWebService::Ichiba::Item.search(keyword: keyword)

    if items.blank?
      Rails.logger.warn "Rakuten API: No items found for '#{keyword}'"
      return nil
    end

    item = items.first

    Rails.logger.info "Rakuten API: Found '#{item['itemName']}'"

    {
      "name" => item["itemName"],
      "url" => item["itemUrl"],
      "imageUrl" => item["mediumImageUrls"]
    }
  rescue => e
    Rails.logger.error "Rakuten API Error: #{e.message}"
    nil
  end
end
