class FetchRakutenProductJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)
    return if product.name.blank?

    Rails.logger.info "Starting Rakuten API fetch for Product ##{product_id}"

    service = RakutenApiService.new
    data = service.search(product.name)

    if data
      product.update(
        rakuten_url: data["url"],
        rakuten_image_url: data["imageUrl"]
      )
      Rails.logger.info "Product ##{product_id}: Successfully fetched data"
    else
      Rails.logger.warn "Product ##{product_id}: No data found"
    end
  rescue => e
    Rails.logger.error "Product ##{product_id}: Error - #{e.message}"
    raise
  end
end
