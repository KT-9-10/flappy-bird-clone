extends CharacterBody2D

@export var jump_strength := 300
@export var gravity := 800
@export var max_fall_speed := 500


func _physics_process(delta: float) -> void:
	# ジャンプ入力受付
	if Input.is_action_just_pressed("jump"):
		velocity.y = 0
		velocity.y -= jump_strength
	# 重力の適用
	velocity.y += gravity * delta
	# Spriteの回転
	#rotation = deg_to_rad(velocity.y * 0.1)
	rotation = deg_to_rad(clamp(velocity.y * 0.1, -15, 45))
	# 最大落下スピードを超えないようにする
	velocity.y = min(velocity.y, max_fall_speed)
	
	move_and_slide()
