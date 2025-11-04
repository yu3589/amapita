class Rack::Attack
  # Cloudflare / proxy 対応用ヘッダ名
  CF_CONNECTING_IP = "HTTP_CF_CONNECTING_IP".freeze
  X_FORWARDED_FOR  = "HTTP_X_FORWARDED_FOR".freeze

  # 実クライアントIPを返す（CF-Connecting-IP -> X-Forwarded-For -> req.ip）
  def self.real_ip(req)
    header = req.get_header(CF_CONNECTING_IP) ||
             req.get_header(X_FORWARDED_FOR)&.split(",")&.first&.strip

    ip = (header || req.ip).to_s.strip

    return req.ip if ip.blank?

    begin
      IPAddr.new(ip)
      ip
    rescue => e
      Rails.logger.warn "Invalid IP detected: #{ip} - #{e.message}"
      req.ip
    end
  end

  # ------------------------------------------------------------
  # 管理者IP許可リスト（現在は不要だが、将来の拡張用に保持）
  # ------------------------------------------------------------
  safelist("admin_ips") do |req|
    admin_ips = ENV.fetch("ADMIN_IPS", "").split(",").map(&:strip).select(&:present?)
    admin_ips.any? && admin_ips.include?(real_ip(req))
  end

  # ------------------------------------------------------------
  # 全体のリクエスト制限（静的アセットは除外）
  # ------------------------------------------------------------
  throttle("req/ip", limit: 500, period: 5.minutes) do |req|
    ip = real_ip(req)
    Rails.logger.info "Rate limiting check for IP: #{ip}"
    real_ip(req) unless req.path.start_with?("/assets")
  end

  # ------------------------------------------------------------
  # User-Agentが怪しいクライアントの制限
  # ------------------------------------------------------------
  throttle("suspicious_user_agent/ip", limit: 3, period: 5.minutes) do |req|
    user_agent = req.user_agent.to_s.downcase

    # 正常なブラウザ・ツールの包括的な除外
    legitimate_agents = %w[
        chrome firefox safari edge opera
        mobile android iphone ipad
        googlebot bingbot slackbot twitterbot
    ]

    next if legitimate_agents.any? { |agent| user_agent.include?(agent) }

    # より具体的な悪意のあるパターンのみ制限
    malicious = user_agent.blank? ||
                user_agent.include?("masscan") ||
                user_agent.include?("nmap") ||
                user_agent.include?("sqlmap")

    real_ip(req) if malicious
  end
end
