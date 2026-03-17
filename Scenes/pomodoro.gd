extends Control

enum Mode { FOCUS, SHORT_BREAK }
enum State { READY, RUNNING, PAUSED }

@export var focus_time := 25
@export var focus_color: Color
@export var short_break_time := 5
@export var short_break_color: Color

var mode: Mode = Mode.FOCUS
var state: State = State.READY
var pomodoro_count: int = 0
var bgm_position: float = 0.0


func _ready() -> void:
	set_mode(Mode.FOCUS)   # 初期モードのセット
	set_state(State.READY) # 初期状態のセット
	apply_mode_time()      # モードの時間をタイマーにセットする
	update_time_label()    # 時間のラベルを更新する 


func _process(_delta: float) -> void:
	# プレイボタンが押されたときm
	if Input.is_action_just_pressed("Play"):
		match state:
			State.READY:
				$Timer.start()
				set_state(State.RUNNING)
			State.RUNNING:
				$Timer.paused = true
				set_state(State.PAUSED)
			State.PAUSED:
				$Timer.paused = false
				set_state(State.RUNNING)
	# リセットボタンが押されたとき
	if Input.is_action_just_pressed("Reset"):
		$Timer.stop()
		$Timer.paused = false
		set_state(State.READY)
		switch_mode()
		apply_mode_time()
	# ミュートボタンが押されたとき
	if Input.is_action_just_pressed("Mute"):
		if $BGM.playing:
			bgm_position = $BGM.get_playback_position()
			$BGM.stop()
		else:
			$BGM.play(bgm_position)
	# アプリを終了する
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()


	# 時間ラベルの更新
	update_time_label()
	# アニメーションの更新
	update_animation()


# モードをセットする
func set_mode(mo: Mode) -> void:
	mode = mo
	match mode:
		Mode.FOCUS:
			$ModeLabel.text = "FOCUS"
			$ModeLabel.add_theme_color_override("font_color", focus_color)
		Mode.SHORT_BREAK:
			$ModeLabel.text = "BREAK"
			$ModeLabel.add_theme_color_override("font_color", short_break_color)


# 状態をセットする
func set_state(st: State) -> void:
	state = st
	match state:
		State.READY:
			$StateLabel.text = "READY"
		State.RUNNING:
			$StateLabel.text = "RUNNING"
		State.PAUSED:
			$StateLabel.text = "PAUSED"


# モードごとの時間をタイマーに設定する
func apply_mode_time() -> void:
	match mode:
		Mode.FOCUS:
			set_wait_timer(focus_time)
		Mode.SHORT_BREAK:
			set_wait_timer(short_break_time)


# 分を秒に変換してタイマーにセットする
func set_wait_timer(minutes: float) -> void:
	$Timer.wait_time = minutes * 60.0


# 時間のラベルを更新する
func update_time_label() -> void:
	match state:
		State.READY:
			$TimeLabel.text = get_time_string($Timer.wait_time)
		State.RUNNING, State.PAUSED:
			$TimeLabel.text = get_time_string($Timer.time_left)


func get_time_string(time: float) -> String:
	var total_seconds: int = ceili(time)
	var m: int = total_seconds / 60
	var s: int = total_seconds % 60
	return "%02d:%02d" % [m, s]
	

func _on_timer_timeout() -> void:
	update_count_label()
	$AlarmSE.play()
	switch_mode()
	set_state(State.READY)
	apply_mode_time()
	update_time_label()


func switch_mode() -> void:
	if mode == Mode.FOCUS:
		set_mode(Mode.SHORT_BREAK)
	else:
		set_mode(Mode.FOCUS)


func update_count_label() -> void:
	if mode == Mode.FOCUS:
		pomodoro_count += 1
		$CountLabel.text = "Pomodoro: " + str(pomodoro_count)
		

func update_animation() -> void:
	if mode == Mode.FOCUS:
		if state == State.RUNNING:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if state == State.RUNNING:
			$AnimatedSprite2D.play("sleep")
		else:
			$AnimatedSprite2D.play("sleep_slow")
