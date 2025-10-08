class RakutenApiService
  MAX_RETRIES = 3
  RETRY_DELAY = 2
  TIMEOUT = 10

  def search(keyword)
    return nil if keyword.blank?

    retries = 0

    begin
      Rails.logger.info "🔍 Rakuten API: Searching for '#{keyword}' (attempt #{retries + 1})"

      items = RakutenWebService::Ichiba::Item.search(
        keyword: keyword,
        timeout: TIMEOUT
      )

      if items.blank?
        Rails.logger.warn "📭 Rakuten API: No items found for '#{keyword}'"
        return nil
      end

      item = items.first

      Rails.logger.info "🎉 Rakuten API: Found '#{item['itemName']}'"

      parse_item(item)

    rescue Timeout::Error, Net::OpenTimeout => e
      retries += 1

      if retries < MAX_RETRIES
        Rails.logger.warn "⏰ Rakuten API Timeout (attempt #{retries}/#{MAX_RETRIES}): #{e.message}. Retrying in #{RETRY_DELAY} seconds..."
        sleep(RETRY_DELAY)
        retry
      else
        Rails.logger.error "💥 Rakuten API: Max retries (#{MAX_RETRIES}) reached. #{e.message}"
        nil
      end

    rescue JSON::ParserError => e
      Rails.logger.error "📄 Rakuten API JSON Parse Error: #{e.message}"
      nil

    rescue StandardError => e
      Rails.logger.error "❌ Rakuten API Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end

  private

  def parse_item(item)
    {
      "name" => item["itemName"] || "",
      "url" => item["itemUrl"] || "",
      "imageUrl" => item["mediumImageUrls"] || ""
    }
  end
end
