module NavigatorHelper
  def content_for_end_date(start_time, end_time)
    content_tag :span, :id => "end-date", :style => _calculate_day_range(start_time, end_time) > 1 ? "" : "display: none;" do
      " - " + end_time.strftime("%B %d, %Y")
    end
  end

  def url_for_tab(tab_name, label, start_time, end_time)
    _validate_tab(tab_name)

    if start_time.beginning_of_day < end_time.beginning_of_day
      _get_date_range_path_for_tab(tab_name, label, start_time, end_time)
    else
      _get_date_path_for_tab(tab_name, label, start_time)
    end
  end

  def link_to_change_mode(start_time, end_time)
    if _calculate_day_range(start_time, end_time) > 1
      content_tag(:a, "choose a single date instead...", :id => "change-mode")
    else
      content_tag(:a, "choose a date range instead...", :id => "change-mode")
    end
  end

  def get_base_path
    @label.present? ? send("label_#{@current_tab}_path", @label) : send("#{@current_tab}_path")
  end

  def get_label_options(start_time, end_time)
    first_option_display_value = "- All Labels -"

    options = []

    start_date = start_time.strftime("%Y-%m-%d")
    end_date = end_time.strftime("%Y-%m-%d")

    if start_time.beginning_of_day < end_time.beginning_of_day
      options << [first_option_display_value, send("date_range_#{@current_tab}_path", start_date , end_date)]
      @labels.each { |label| options << [label.name, send("date_range_label_#{@current_tab}_path", label, start_date, end_date)] }
    else
      options << [first_option_display_value, send("date_#{@current_tab}_path", start_date)]
      @labels.each { |label| options << [label.name, send("date_label_#{@current_tab}_path", label, start_date)] }
    end

    options
  end

  def link_to_date_range_back(label, start_time, end_time)
    link_to raw("&laquo;"), _date_range_back_path(label, start_time, end_time), :id => "back"
  end

  def link_to_date_range_forward(label, start_time, end_time)
    link_to raw("&raquo;"), _date_range_forward_path(label, start_time, end_time), :id => "forward"
  end

  private

  def _calculate_day_range(start_time, end_time)
    raise ArgumentError.new("start_time must be before end_time") if start_time > end_time

    ((end_time.end_of_day - start_time.end_of_day) / 60 / 60 / 24) + 1
  end

  def _date_range_back_path(label, start_time, end_time)
    day_range = _calculate_day_range(start_time, end_time)

    if day_range > 1
      _get_date_range_path_for_tab(@current_tab, label, (start_time.beginning_of_day - day_range.days), (start_time.beginning_of_day - 1.day))
    else
      _get_date_path_for_tab(@current_tab, label, (start_time.beginning_of_day - 1.day))
    end
  end

  def _date_range_forward_path(label, start_time, end_time)
    day_range = _calculate_day_range(start_time, end_time)

    if day_range > 1
      _get_date_range_path_for_tab(@current_tab, label, (end_time.beginning_of_day + 1.days), (end_time.beginning_of_day + day_range.days))
    else
      _get_date_path_for_tab(@current_tab, label, (end_time.beginning_of_day + 1.day))
    end
  end

  def _get_date_range_path_for_tab(tab_name, label, start_time, end_time)
    _validate_tab(tab_name)

    if label.present?
      send("date_range_label_#{tab_name}_path", label, start_time.strftime("%Y-%m-%d"), end_time.strftime("%Y-%m-%d"))
    else
      send("date_range_#{tab_name}_path", start_time.strftime("%Y-%m-%d"), end_time.strftime("%Y-%m-%d"))
    end
  end

  def _get_date_path_for_tab(tab_name, label, start_time)
    _validate_tab(tab_name)

    if label.present?
      send("date_label_#{tab_name}_path", label, start_time.strftime("%Y-%m-%d"))
    else
      send("date_#{tab_name}_path", start_time.strftime("%Y-%m-%d"))
    end
  end

  def _validate_tab(tab_name)
    unless Mobonotes::Application.config.tab_names.include?(tab_name)
      raise ArgumentError.new("The tab \"#{tab_name}\" has not been configured and is therefore invalid. Please check initializers.")
    end
  end
end