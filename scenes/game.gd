extends Node2D

enum State { START, PLAY, GAME_OVER, RESTART_WAIT }

var score: int
var current_state: State
var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn")
var difficulty: int
var messages: Dictionary = {
	"start": "PRESS SPACE / CLICK TO FLAP",
	"retry": "PRESS SPACE / CLICK TO RETRY",
}


func _ready() -> void:
	Global.load_high_score()
	# スコアの初期化
	score = 0
	$UI/ScoreLabel.text = str(score)
	$UI/HighScoreLabel.text = "HIGH SCORE: " + str(Global.high_score)
	# 状態の初期化
	current_state = State.START 
	# UIの初期化
	$UI/TitleLabel.show()
	$UI/GameOverLabel.hide()
	$UI/MessageLabel.text = messages["start"]
	$UI/MessageLabel.show()
	# 難易度の初期化
	difficulty = 0


func start_game() -> void:
	current_state = State.PLAY
	$UI/TitleLabel.hide()
	$UI/MessageLabel.hide()
	$SpawnTimer.start()
	$LevelUpTimer.start()

func game_over() -> void:
	current_state = State.GAME_OVER 
	$LevelUpTimer.stop()
	$UI/GameOverLabel.show()
	$GameOverSE.play()
	if score > Global.high_score:
		Global.high_score = score
		Global.save_high_score()
		$UI/HighScoreLabel.text = "HIGH SCORE: " + str(Global.high_score)
	await get_tree().create_timer(1.5).timeout
	$UI/MessageLabel.text = messages["retry"]
	$UI/MessageLabel.show()
	current_state = State.RESTART_WAIT


func spawn_pipe() -> void:
	var pipe: Node2D = pipe_scene.instantiate()
	pipe.position = Vector2(170, randf_range(-32, 32))
	pipe.connect("passed", add_score)
	$Obstacles.add_child(pipe)
	pipe.difficulty = difficulty

	
func add_score() -> void:
	if current_state == State.PLAY:
		score += 1
		$UI/ScoreLabel.text = str(score)


func _on_timer_timeout() -> void:
	spawn_pipe()


func _on_level_up_timer_timeout() -> void:
	# 難易度上昇
	difficulty += 1
	for p in $Obstacles.get_children():
		p.difficulty = difficulty
	# パイプの発声間隔を短く
	$SpawnTimer.wait_time *= 0.95
