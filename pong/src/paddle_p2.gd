class_name Paddle_P2 extends CharacterBody2D

func _physics_process(delta):
	var axis = Input.get_axis("p2_up", "p2_down")
	velocity = Vector2(0, axis) * 1000
	move_and_slide()
