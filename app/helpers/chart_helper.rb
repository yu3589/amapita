module ChartHelper
  def sweetness_label(user_post: nil, post: nil)
    if user_post.present? || (post.present? && current_user == post.user)
      t("defaults.chart.sweetness_user")
    else
      t("defaults.chart.sweetness_other_user")
    end
  end
end
