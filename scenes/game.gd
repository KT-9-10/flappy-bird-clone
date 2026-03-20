extends Node2D

var score: int = 0
var current_state: State
var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn")

enum State { START, PLAY, GAME_OVER }


func _ready() -> void:
	current_state = State.START
	$TitleLabel.show()
	$GameOverLabel.hide()


func start_game() -> void:
	current_state = State.PLAY
	$TitleLabel.hide()
	$SpawnTimer.start()


func game_over() -> void:
	current_state = State.GAME_OVER
	$GameOverLabel.show()
	


func spawn_pipe() -> void:
	var pipe: Node2D = pipe_scene.instantiate()
	pipe.position = Vector2(170, randf_range(-40, 40))
	pipe.connect("passed", add_score)
	$Obstacles.add_child(pipe)
	
	
func add_score() -> void:
	score += 1
	print("Score: ", score)


func _on_timer_timeout() -> void:
	spawn_pipe()
