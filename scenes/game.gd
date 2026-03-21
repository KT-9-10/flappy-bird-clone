extends Node2D

var score: int
var current_state: State
var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn")

enum State { START, PLAY, GAME_OVER }


func _ready() -> void:
	# スコアの初期化
	score = 0
	$UI/ScoreLabel.text = str(score)
	$UI/HighScoreLabel.text = "HIGH SCORE: " + str(Global.high_score)
	# 状態の初期化
	current_state = State.START 
	# UIの初期化
	$UI/TitleLabel.show()
	$UI/GameOverLabel.hide()


func _process(_delta: float) -> void:
	pass


func start_game() -> void:
	current_state = State.PLAY
	$UI/TitleLabel.hide()
	$SpawnTimer.start()


func game_over() -> void:
	current_state = State.GAME_OVER
	$UI/GameOverLabel.show()
	if score > Global.high_score:
		Global.high_score = score
		$UI/HighScoreLabel.text = "HIGH SCORE: " + str(Global.high_score)


func spawn_pipe() -> void:
	var pipe: Node2D = pipe_scene.instantiate()
	pipe.position = Vector2(170, randf_range(-40, 40))
	pipe.connect("passed", add_score)
	$Obstacles.add_child(pipe)
	
	
func add_score() -> void:
	if current_state == State.PLAY:
		score += 1
		$UI/ScoreLabel.text = str(score)


func _on_timer_timeout() -> void:
	spawn_pipe()
