extends Area2D

enum MARKS {
	X, O
}
var mark_scene: PackedScene = load("res://Mark.tscn")
var data = [null, null, null, null, null, null, null, null, null]
var tile_size = 96

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouseEvent = event as InputEventMouseButton
		if mouseEvent.pressed and mouseEvent.button_index == MOUSE_BUTTON_LEFT:
			var coords = local_to_map(mouseEvent.position)
			if (data[to_array_index(coords)] == null):
				# "draw" a mark at the location of the mouse.
				var new_mark = mark_scene.instantiate() as Sprite2D
				new_mark.frame = MARKS.X
				new_mark.position = coords * tile_size
				add_child(new_mark)
				# update inner array
				data[to_array_index(coords)] = MARKS.X
				if check_win(MARKS.X):
					won("player_1")
					return
				# opponent moves
				bot_make_move()
				if check_win(MARKS.O):
					won("bot")
					return


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


func check_win(mark):
	for i in 3:
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

# a simple mechanism to notify winner.
func won(player):
	$Label.text = player + " won!"
	input_pickable = false

# convert from pixel position to map coordinates
# eg. Vector2(88, 124) -> Vector2i(1, 2)
func local_to_map(v2: Vector2) -> Vector2i:
	return Vector2i((v2 / tile_size).floor())

# convert between map coords and array index.
# eg. Vector2i(1, 1) <-> 4
func to_coords(idx: int) -> Vector2i:
	return Vector2i(idx % 3, floori(idx / 3))

func to_array_index(coords: Vector2i) -> int:
	return coords.x + (coords.y * 3)
