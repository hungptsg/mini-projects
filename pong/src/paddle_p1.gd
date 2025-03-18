class_name Paddle_P1 extends CharacterBody2D

func _physics_process(delta):
	var axis = Input.get_axis("p1_up", "p1_down")
	velocity = Vector2(0, axis) * 1000
	move_and_slide()
