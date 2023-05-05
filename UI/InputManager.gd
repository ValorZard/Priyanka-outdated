extends Control

class_name InputManager

var game_board : GameBoard
var cursor : Cursor
var camera3d : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	game_board = get_parent()
	cursor = $Cursor
	camera3d = $"../Camera3D"
	$AttackButton.connect("button_up", game_board.do_attack)
	$UndoButton.connect("button_up", game_board.undo_command)

# if the cursor is currently over a button or other UI element, don't allow it to click to move the unit
func cursor_can_click() -> bool:
	if $AttackButton.is_hovered() or $UndoButton.is_hovered():
		return false
	return true

# get value if we were actually able to get an input for movement or not
func is_movement_selected() -> bool:
	# only want to actually set the position we want the unit to move to on click
	if Input.is_action_just_released("left_mouse_click") and cursor_can_click():
		game_board.do_movement(cursor.direction_to_cursor, cursor.distance_to_cursor)
		return true
	return false

func do_current_unit_actions():
	if game_board.get_current_unit() is PlayerUnit:
		# do not move on unless the player actually does an input for the player unit
		cursor.update_cursor(camera3d, game_board.get_current_unit())
		is_movement_selected()
		pass
	else:
		print("on unit: ", game_board.get_current_unit().name)
		# TODO: Actiually have an AI here
		game_board.get_current_unit().set_action_points(0)
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_current_unit_actions()
	$StatsLabel.text = str(game_board.get_current_unit().name, " Action Points: ", game_board.get_current_unit().action_points)