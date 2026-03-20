extends Node2D

var current_state: State

enum State { START, PLAY, GAME_OVER }


func _ready() -> void:
	current_state = State.START


func start_game() -> void:
	current_state = State.PLAY
	$TitleLabel.hide()


func game_over() -> void:
	current_state = State.GAME_OVER
	$GameOverLabel.show()
