extends CharacterBody2D

@export var jump_strength := 280
@export var gravity := 800
@export var max_fall_speed := 400
var can_restart := false

@onready var game = get_parent()


func _physics_process(delta: float) -> void:
	match game.current_state:
		game.State.START:
			if Input.is_action_just_pressed("jump"):
				game.start_game()
				jump()
		game.State.PLAY:
			# ジャンプ入力受付
			if Input.is_action_just_pressed("jump"):
				jump()
			# 重力の適用
			velocity.y += gravity * delta
			# Spriteの回転
			rotation = deg_to_rad(clamp(velocity.y * 0.1, -15, 45))
			# 最大落下スピードを超えないようにする
			velocity.y = min(velocity.y, max_fall_speed)
		game.State.GAME_OVER:
			if Input.is_action_just_pressed("jump") and can_restart:
				get_tree().reload_current_scene()
				return
			# 重力の適用
			velocity.y += gravity * delta
			# Spriteの回転
			rotation += 0.5
	
	move_and_slide()


func jump() -> void:
	velocity.y = 0
	velocity.y -= jump_strength


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	game_over()


func game_over():
	if game.current_state == game.State.PLAY:
		game.game_over()
		velocity.x = randf_range(-100, 100)
		if position.y > 0:
			jump()
		else:
			velocity.y = 0
		# 一瞬入力を受け付けなくする
		can_restart = false
		await get_tree().create_timer(0.5).timeout
		can_restart = true
