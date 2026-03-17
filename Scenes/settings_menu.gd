extends Control

signal closed

func _ready() -> void:
	var focus_line_edit: LineEdit = $VBoxContainer/FocusHBox/SpinBox.get_line_edit()
	var short_break_line_edit: LineEdit = $VBoxContainer/SBreakHBox/SpinBox.get_line_edit()
	var font = load("res://Fonts/x10y12pxDonguriDuel.ttf")
	focus_line_edit.add_theme_font_override("font", font)
	focus_line_edit.add_theme_font_size_override("font_size", 24)
	short_break_line_edit.add_theme_font_override("font", font)
	short_break_line_edit.add_theme_font_size_override("font_size", 24)
	setup()
	
	
func setup() -> void:
	$VBoxContainer/FocusHBox/SpinBox.value = Global.focus_time
	$VBoxContainer/SBreakHBox/SpinBox.value = Global.short_break_time


func _on_save_button_pressed() -> void:
	Global.focus_time = $VBoxContainer/FocusHBox/SpinBox.value
	Global.short_break_time = $VBoxContainer/SBreakHBox/SpinBox.value
	closed.emit()


func _on_cancel_button_pressed() -> void:
	closed.emit()
