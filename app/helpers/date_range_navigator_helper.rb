module DateRangeNavigatorHelper
  def link_to_date_range_back(start_time, end_time)
    day_range = calculate_day_range(start_time, end_time)
    if day_range > 1
      new_start_time = start_time - day_range.days
      new_end_time = new_start_time + (day_range - 1).days 
      link_to raw("&laquo;"), date_range_path(new_start_time.strftime("%Y-%m-%d"), new_end_time.strftime("%Y-%m-%d")), :id => "back"
    else
      link_to raw("&laquo;"), date_path((start_time - 1.day).strftime("%Y-%m-%d")), :id => "back"
    end
  end

  def link_to_date_range_forward(start_time, end_time)
    day_range = calculate_day_range(start_time, end_time)
    if day_range > 1
      new_start_time = end_time.beginning_of_day + 1.days
      new_end_time = new_start_time + (day_range - 1).days
      link_to raw("&raquo;"), date_range_path(new_start_time.strftime("%Y-%m-%d"), new_end_time.strftime("%Y-%m-%d")), :id => "forward"
    else
      link_to raw("&raquo;"), date_path((end_time + 1.day).strftime("%Y-%m-%d")), :id => "forward"
    end
  end

  def content_for_end_date(start_time, end_time)
    day_range = calculate_day_range(start_time, end_time)
    content_tag :span, :id => "end-date", :style => day_range > 1 ? "" : "display: none;" do
      " - " + end_time.strftime("%b %d, %Y")      
    end
  end

  def link_to_change_mode(start_time, end_time)
    day_range = calculate_day_range(start_time, end_time)
    if day_range > 1
      content_tag(:a, "choose a single date instead...", :id => "change-mode")
    else
      content_tag(:a, "choose a date range instead...", :id => "change-mode")
    end
  end

  def calculate_day_range(start_time, end_time)
    ((end_time.end_of_day - start_time.end_of_day) / 60 / 60 / 24) + 1
  end
end