extends Control


func setup(f_time: int, sb_time: int):
	var focus_line_edit: LineEdit = $VBoxContainer/FocusHBox/SpinBox.get_line_edit()
	focus_line_edit.text = str(f_time)
	var short_break_line_edit: LineEdit = $VBoxContainer/SBreakHBox/SpinBox.get_line_edit()
	short_break_line_edit.text = str(sb_time)
