extends Control

class_name UIManager

var game_board : GameBoard
var cursor : Cursor

# Called when the node enters the scene tree for the first time.
func _ready():
	game_board = get_parent()
	cursor = $Cursor
	$AttackButton.connect("button_up", game_board.do_attack)
	$UndoButton.connect("button_up", game_board.undo_command)

# if the cursor is currently over a button or other UI element, don't allow it to click to move the unit
func cursor_can_click() -> bool:
	if $AttackButton.is_hovered() or $UndoButton.is_hovered():
		return false
	return true

func print_message(message : String):
	$Label.text = message

# get value if we were actually able to get an input for movement or not
func is_movement_selected() -> bool:
	# only want to actually set the position we want the unit to move to on click
	if Input.is_action_just_released("left_mouse_click") and cursor_can_click():
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$StatsLabel.text = str(game_board.get_current_unit().name, " Action Points: ", game_board.get_current_unit().action_points)
