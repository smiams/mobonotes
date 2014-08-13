module DateRangeNavigatorHelper
  def link_to_date_range_back(start_time, end_time)
    link_to raw("&laquo;"), _date_range_back_path(start_time, end_time), :id => "back"
  end

  def link_to_date_range_forward(start_time, end_time)
    link_to raw("&raquo;"), _date_range_forward_path(start_time, end_time), :id => "forward"
  end

  def content_for_end_date(start_time, end_time)
    content_tag :span, :id => "end-date", :style => _calculate_day_range(start_time, end_time) > 1 ? "" : "display: none;" do
      " - " + end_time.strftime("%b %d, %Y")      
    end
  end

  def link_to_change_mode(start_time, end_time)
    if _calculate_day_range(start_time, end_time) > 1
      content_tag(:a, "choose a single date instead...", :id => "change-mode")
    else
      content_tag(:a, "choose a date range instead...", :id => "change-mode")
    end
  end

  private

  def _calculate_day_range(start_time, end_time)
    ((end_time.end_of_day - start_time.end_of_day) / 60 / 60 / 24) + 1
  end

  def _date_range_back_path(start_time, end_time)
    day_range = _calculate_day_range(start_time, end_time)

    if day_range > 1
      new_start_time = start_time - day_range.days
      new_end_time = new_start_time + (day_range - 1).days 

      if @current_controller == "labels"
        return date_range_label_path(@current_id, new_start_time.strftime("%Y-%m-%d"), new_end_time.strftime("%Y-%m-%d"))
      else
        return date_range_path(new_start_time.strftime("%Y-%m-%d"), new_end_time.strftime("%Y-%m-%d"))
      end
    else
      if @current_controller == "labels"
        return date_label_path(@current_id, (start_time - 1.day).strftime("%Y-%m-%d"))
      else
        return date_path((start_time - 1.day).strftime("%Y-%m-%d"))
      end
    end
  end

  def _date_range_forward_path(start_time, end_time)
    day_range = _calculate_day_range(start_time, end_time)
    if day_range > 1
      new_start_time = end_time.beginning_of_day + 1.days
      new_end_time = new_start_time + (day_range - 1).days

      if @current_controller == "labels"
        return date_range_label_path(@current_id, new_start_time.strftime("%Y-%m-%d"), new_end_time.strftime("%Y-%m-%d"))
      else
        return date_range_path(new_start_time.strftime("%Y-%m-%d"), new_end_time.strftime("%Y-%m-%d"))
      end
    else
      if @current_controller == "labels"
        return date_label_path(@current_id, (end_time + 1.day).strftime("%Y-%m-%d"))
      else
        return date_path((end_time + 1.day).strftime("%Y-%m-%d"))
      end
    end
  end
end