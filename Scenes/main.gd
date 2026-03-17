extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SettingMenu"):
		toggle_settings_menu()


func toggle_settings_menu() -> void:
	if $SettingsMenu.visible:
		close_settings_menu()
	else:
		open_settings_menu()


func open_settings_menu() -> void:
	$Pomodoro.set_process(false)
	$SettingsMenu.setup()
	$SettingsMenu.show()


func close_settings_menu() -> void:
	$Pomodoro.set_process(true)
	$SettingsMenu.hide()
	$Pomodoro.apply_mode_time()


func _on_settings_menu_closed() -> void:
	$Pomodoro.set_process(true)
	$SettingsMenu.hide()
	$Pomodoro.apply_mode_time()
