Mobonotes::Application.config.tab_mappings = {
  "tasks" => "tasks",
  "labels/tasks" => "tasks",  
  "notes" => "notes",
  "labels/notes" => "notes"
}

Mobonotes::Application.config.tab_names = Mobonotes::Application.config.tab_mappings.values.uniq