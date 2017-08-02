module DateAndTimeHelper

  def activity_dates item
    t("activity_dates", model_name: item.class.model_name.human, created_at_rel: item.created_at.to_formatted_s(:db), updated_at: item.updated_at.to_s(:short), updated_at_rel: item.updated_at.to_formatted_s(:db)).html_safe
  end
  
  def short_date date, nil_string = '-'
    date.present? ? date.to_date.strftime("%e %b %Y") : nil_string
  end
  
end
