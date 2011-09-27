module NoteSorting
  private
  
  def _sort_notes_for_display(notes=[])
    @note_creation_dates ||= { Time.zone.now.to_date => [] }
    notes.each { |note| _add_note_to_creation_date(note) }
    @note_creation_dates = @note_creation_dates.sort { |less, greater| greater <=> less }
  end

  def _add_note_to_creation_date(note)
    @note_creation_dates ||= { Time.zone.now.to_date => [] }
    notes = @note_creation_dates[note.created_at.to_date] || []
    notes << note
    notes.sort! { |less, greater| greater.created_at <=> less.created_at }
    @note_creation_dates[note.created_at.to_date] = notes
  end    
end