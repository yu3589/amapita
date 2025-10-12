class RakutenApiService
  MAX_RETRIES = 3
  RETRY_DELAY = 2
  TIMEOUT = 10
  DEFAULT_SEARCH_RESULTS_COUNT = 10
  DEFAULT_GENRES = [ 551167, 100316 ] #  スイーツ・お菓子, 飲み物

  def search(keyword, options = {})
    return nil if keyword.blank?

    retries = 0

    begin
      Rails.logger.info "🔍 Rakuten API: Searching for '#{keyword}' (attempt #{retries + 1})"
      # 指定したジャンルから商品を検索（ジャンル別に実行）
      all_items = DEFAULT_GENRES.flat_map do |genre|
      Rails.logger.debug "👀 Searching in genre: #{genre}"

      begin

        items = RakutenWebService::Ichiba::Item.search(
            keyword: keyword,
            genreId: genre.to_s,
            timeout: TIMEOUT,
            hits: DEFAULT_SEARCH_RESULTS_COUNT
          )

          items.to_a
        rescue => e
          # 指定したジャンルで検索失敗した場合
          Rails.logger.warn "⚠️ Genre #{genre} failed: #{e.message}"
          []
        end
      end

      if all_items.blank?
        Rails.logger.warn "📭 Rakuten API: No items found for '#{keyword}'"
        return []
      end
      # 重複を削除
      unique_items = all_items.uniq { |item| item["itemUrl"] }
      # データから必要な情報だけを抽出
      results = unique_items.map { |item| parse_item(item) }

      Rails.logger.info "🎉 Rakuten API: Found #{results.size} unique items (#{all_items.size} total)"

      results.take(DEFAULT_SEARCH_RESULTS_COUNT)

    rescue Timeout::Error, Net::OpenTimeout => e
      retries += 1

      if retries < MAX_RETRIES
        Rails.logger.warn "⏰ Rakuten API Timeout (attempt #{retries}/#{MAX_RETRIES}): #{e.message}. Retrying in #{RETRY_DELAY} seconds..."
        sleep(RETRY_DELAY)
        retry
      else
        Rails.logger.error "💥 Rakuten API: Max retries (#{MAX_RETRIES}) reached. #{e.message}"
        []
      end

    rescue JSON::ParserError => e
      Rails.logger.error "📄 Rakuten API JSON Parse Error: #{e.message}"
    []

    rescue StandardError => e
      Rails.logger.error "❌ Rakuten API Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      []
    end
  end

  private

  def parse_item(item)
    {
      "name" => item["itemName"] || "",
      "url" => item["itemUrl"] || "",
      "shopName" => item["shopName"] || "",
      "imageUrl" => extract_image_url(item)
    }
  end

  def extract_image_url(item)
    urls = item["mediumImageUrls"]
    # 画像URLのデータ形式に応じて
    if urls.is_a?(Array) && urls.any?
      first_item = urls.first

      if first_item.is_a?(Hash)
        return first_item["imageUrl"] || ""
      end

      return first_item if first_item.is_a?(String)
    end

    return urls if urls.is_a?(String)

    Rails.logger.debug "❌📷 No valid image URL found for item: #{item['itemName']}"
    ""
  end
end
