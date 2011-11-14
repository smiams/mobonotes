module ObjectSorting
  def self.sort_tasks_for_display(tasks=[])
    task_creation_dates ||= { Time.zone.now.to_date => [] }
    tasks.each { |task| self._add_task_to_creation_date(task, task_creation_dates) }
    return task_creation_dates
  end

  def self._add_task_to_creation_date(task, task_creation_dates)
    tasks = task_creation_dates[task.created_at.to_date] || []
    tasks << task
    # tasks.sort! { |less, greater| greater.created_at <=> less.created_at }
    task_creation_dates[task.created_at.to_date] = tasks
  end    

  def self.sort_notes_for_display(notes=[])
    note_creation_dates ||= { Time.zone.now.to_date => [] }
    notes.each { |note| self._add_note_to_creation_date(note, note_creation_dates) }
    return note_creation_dates
  end

  def self._add_note_to_creation_date(note, note_creation_dates)
    notes = note_creation_dates[note.created_at.to_date] || []
    notes << note
    notes.sort! { |less, greater| greater.created_at <=> less.created_at }
    note_creation_dates[note.created_at.to_date] = notes
  end    
end