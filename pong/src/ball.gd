class_name Ball extends RigidBody2D

signal scored(player: String)
var original_position = position
@onready var boundary_left = get_viewport_rect().position.x
@onready var boundary_right = get_viewport_rect().size.x

func _integrate_forces(state):
	# if ball is out of bound...
	if position.x < boundary_left or position.x > boundary_right:
		# repostion and relaunch.
		_reset_posision_and_speed(state)
		launch_at_random_direction()
		var scorer = "p1" if position.x > boundary_left else "p2"
		scored.emit(scorer)
	# if ball touch anything...
	for i in get_contact_count():
		$AudioStreamPlayer2D.play() # play an impact sound.
		apply_impulse(state.linear_velocity * 0.15) # increase speed.
		# allow the ball to be affected by the player movement,
		# making it hard for the opponent to predict the trajectory.
		var collider_obj = state.get_contact_collider_object(i)
		if collider_obj is Paddle_P1 or collider_obj is Paddle_P2:
			var velo = collider_obj.velocity * 0.2
			apply_impulse(velo)

func _reset_posision_and_speed(state):
	state.transform = Transform2D(0, original_position)
	linear_velocity = Vector2.ZERO

func launch_at_random_direction():
	var dir = Vector2(
		randi_range(50, 10) * [-1, 1].pick_random(),
		randi_range(50, 10) * [-1, 1].pick_random())
	apply_impulse(Vector2(dir.normalized() * 300))
