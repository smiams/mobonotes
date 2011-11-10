module TaskSorting
  def _sort_tasks_for_display(tasks=[])
    @task_creation_dates ||= { Time.zone.now.to_date => [] }
    tasks.each { |task| _add_task_to_creation_date(task) }
    @task_creation_dates
  end

  def _add_task_to_creation_date(task)
    @task_creation_dates ||= { Time.zone.now.to_date => [] }
    tasks = @task_creation_dates[task.created_at.to_date] || []
    tasks << task
    tasks.sort! { |less, greater| greater.created_at <=> less.created_at }
    @task_creation_dates[task.created_at.to_date] = tasks
  end    
end