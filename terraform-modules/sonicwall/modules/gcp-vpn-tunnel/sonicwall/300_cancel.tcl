# exit configuration mode, use cancel to prevent prompt for unsaved config changes
send "cancel $newline" ;# no need to save changes here, all changes have already been saved
expect "$initial_prompt"
