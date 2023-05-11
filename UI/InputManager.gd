extends Control

class_name InputManager

@export var game_board : GameBoard
@export var cursor : Cursor
@export var camera3d : Camera3D
@export var turn_timer : Timer 
@export var input_buffer_timer : Timer

var mouse_in_ui := false

var is_game_over : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$CardDeck.set_game_board(game_board)
	$AttackButton.connect("button_up", do_current_unit_base_attack)
	$UndoButton.connect("button_up", game_board.undo_command)
	$BackToMenuButton.connect("button_up", go_back_to_menu)
	for node in get_all_children(self):
		if node != self: # we dont want to count self as something the mouse can enter and exit
			# use Callable.bind to make the signal have extra parameters when detected
			node.connect("mouse_entered", set_mouse_in_ui.bind(node))
			node.connect("mouse_exited", set_mouse_out_of_ui.bind(node))

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func go_back_to_menu():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")

func set_mouse_in_ui(node):
	#print("mouse in ui, from ", node.name)
	mouse_in_ui = true

func set_mouse_out_of_ui(node):
	#print("mouse out of ui, from ", node.name)
	mouse_in_ui = false


# if the cursor is currently over a button or other UI element, don't allow it to click to move the unit
func cursor_can_click() -> bool:
	return !mouse_in_ui

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
		is_movement_selected()
		pass
	else:
		#print("on unit: ", game_board.get_current_unit().name)
		# TODO: Actiually have an AI here
		game_board.do_attack(game_board.get_current_unit().base_attack_damage, game_board.get_current_unit().base_attack_action_point_cost)
		game_board.get_current_unit().set_action_points(0)

# called when the attack button is pressed, does the unit's base attack (different from Card attacks)
func do_current_unit_base_attack():
	game_board.do_attack(game_board.get_current_unit().base_attack_damage, game_board.get_current_unit().base_attack_action_point_cost)

func update_ui():
	$StatsLabel.text = str("It's ",game_board.get_current_unit().name, " Turn! \nHP: ", game_board.get_current_unit().health, "\nAction Points: ", game_board.get_current_unit().action_points)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor.update_cursor(camera3d, game_board.get_current_unit())
	# only care about doing the game loop if a side hasn't won yet
	if !game_board.check_if_one_side_won():
		# once a unit has finished its turn, the next once can go
		# also make sure inputs from the previous scene don't accidentally carry over here
		if turn_timer.is_stopped() and input_buffer_timer.is_stopped():
			do_current_unit_actions()
			update_ui()
			# check if current unit is out of action points. If so, move on to the next unit
			if game_board.get_current_unit().action_points <= 0:
				game_board.go_to_next_unit()
				# restart timer now that the unit can't do anything more
				turn_timer.start()
	else:
		if is_game_over == false:
			game_board.log_event("Game Over!")
			is_game_over = true
		pass
