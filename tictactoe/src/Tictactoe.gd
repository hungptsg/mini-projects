extends Area2D

enum MARKS {
	X, O
}
var mark_scene :PackedScene = load("res://Mark.tscn")
var data = [null, null, null, null, null, null, null, null, null]
var tile_size = 96

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var coords = local_to_map(get_global_mouse_position())
			if (data[to_array_index(coords)] == null):
				# "draw" a mark at the location of the mouse.
				var new_mark = mark_scene.instantiate() as Sprite2D
				new_mark.frame = MARKS.X
				new_mark.position = coords * tile_size
				add_child(new_mark)
				# update inner array
				data[to_array_index(coords)] = MARKS.X
				print(data)
				
				# bot make move
				bot_make_move()
				
				# check winner
				check_winner()


func bot_make_move():
	var array = range(0, 9)
	array.shuffle()
	for i in array:
		if data[i] == null:
			var new_mark = mark_scene.instantiate() as Sprite2D
			new_mark.frame = MARKS.O
			new_mark.position = to_coords(i) * tile_size
			add_child(new_mark)
			data[i] = MARKS.O
			return



func check_winner():
	if check(MARKS.X):
		won("player_1")
		return
	if check(MARKS.O):
		won("bot")
		return


func check(mark):
	for i in 3:
		# 0   1   2
		# 3   4   5
		# 6   7   8
		# rows
		if data[i * 3] == mark and data[i * 3 + 1] == mark and data[i * 3 + 2] == mark:
			return true
		# columns
		if data[i] == mark and data[i + 3] == mark and data[i + 6] == mark:
			return true
	# diagonals 
	if data[0] == mark and data[4] == mark and data[8] == mark:
		return true
	if data[2] == mark and data[4] == mark and data[6] == mark:
		return true
	pass



func won(player):
	$CanvasLayer/Label.text = player + " won!"
	input_pickable = false

func local_to_map(v2: Vector2) -> Vector2i:
	return Vector2i((v2 / tile_size).floor())

func to_coords(idx: int) -> Vector2i:
	return Vector2i(idx % 3, floori(idx / 3))

func to_array_index(coords: Vector2i) -> int:
	return coords.x + (coords.y * 3)
