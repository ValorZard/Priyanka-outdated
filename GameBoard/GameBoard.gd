extends Node3D

class_name GameBoard

# GameBoard: only handles input from player
# CombatManager: handles all the meta data for the combat encounter (turn order, initiative, all that good stuff)
# CharacterUnit should only handle data relevant to that unit plus animation maybe

var mouse_button_clicked : bool = false
# actual data
#var move_to_position : Vector3 = Vector3.ZERO
var command_array : Array
var units_in_initative_order : Array[BaseUnit]
var current_unit_index : float
# visual data
@export var character_ui_circle_width : float = 1
@onready var event_label : RichTextLabel = $InputManager/EventLabel
var event_queue : Array[String]

# signals
signal game_board_setup_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	current_unit_index = 0
	# set up all the units in initative order
	for node in get_children():
		if node is BaseUnit:
			units_in_initative_order.append(node)
	#print(units_in_initative_order)
	enable_current_unit(true)
	game_board_setup_finished.emit()

# generate "line" between cursor and player for UI purposes
# NOTE: Doesn't currently work properly, rotation is a bit jank
#func render_placement_line(cursor_position : Vector3):
#	$BoxLine.position = ($CharacterUnit.position + cursor_position) / 2
#	$BoxLine.width = ($CharacterUnit.position - cursor_position).length()
#	$BoxLine.rotation.y = $CharacterUnit.position.angle_to(cursor_position)

# put this in game board since it just makes more sense, even though i have to refer to the current unit too much
func enable_current_unit(first_time : bool = false):
	# restore action points and other important things
	get_current_unit().refill_action_points()
	# refill cards in card hand from deck 
	# TODO: turn this into a command somehow so I can undo/redo
	var amount_of_cards_to_refill : int = get_current_unit().max_amount_of_cards_in_hand - get_current_unit().card_hand.size()
	for i in amount_of_cards_to_refill:
		var draw_card_cmd : DrawCardCommand = DrawCardCommand.new(self)
		# if the command doesn't work, break the loop since that means there's no more cards avaliable to draw
		if !draw_card_cmd.execute():
			break
		else:
			# when we first spawn the unit in, we don't want to be able to undo the draw card actions since those are the starting cards
			if !first_time:
				self.command_array.push_back(draw_card_cmd)
	# enable unit specific ui
	get_current_unit().ui_circle.visible = true
	get_current_unit().render_ui_circle()

func disable_current_unit():
	# disable unit specific ui
	get_current_unit().ui_circle.visible = false

func log_event(message : String):
	event_queue.push_front(message)
	event_label.text = ""
	for event in event_queue:
		event_label.text += event + "\n"

# logic functions
func get_current_unit():
	return units_in_initative_order[current_unit_index]

#idk if this is a bad idea or not to do this, but we'll see!
func add_command(command : Command):
	command_array.push_back(command)

func undo_command():
	if !command_array.is_empty():
		command_array.pop_back().undo()

# make the current unit controlled by the game board attack
func do_attack(damage_dealt : int, action_point_cost : int) -> bool:
	var attack_command := AttackCommand.new(self, $EnemyUnit, damage_dealt, action_point_cost)
	if attack_command.execute():
		command_array.push_back(attack_command)
		return true
	else:
		return false

# make the current unit controlled by the game board move
func do_movement(direction : Vector3, distance : float):
	var movement_command := MovementCommand.new(self, direction, distance)
	if movement_command.execute():
		command_array.push_back(movement_command)

func play_card():
	pass

func check_if_one_side_won() -> bool:
	var number_of_player_units : int = 0
	var number_of_enemy_units : int = 0
	for unit in units_in_initative_order:
		if !unit.is_dead():
			if unit is PlayerUnit:
				number_of_player_units += 1
			elif unit is EnemyUnit:
				number_of_enemy_units += 1
	return (number_of_enemy_units == 0) or (number_of_player_units == 0)


# once all of the unit's action points are used up, move on to next unit
# TODO: Turnt hsi to a command so we can undo/redo
func go_to_next_unit():
	# clean up stuff with the current unit
	disable_current_unit()
	#go to next unit. if reached the end, go back to the start
	current_unit_index += 1
	if current_unit_index >= units_in_initative_order.size():
		current_unit_index = 0
	# if the new unit we're on is dead, move on to the next one
	if get_current_unit().is_dead() and !check_if_one_side_won():
		go_to_next_unit()
	# set up new unit
	enable_current_unit()
	#print("moving on to next unit : ", current_unit_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# GAME LOOP -> update every single unit in the field, and let the player control the player units
	# update cursor data so we can use it for movement purposes
	# render UI stuff
	#render_placement_line($Cursor.position)
	#render_character_ui_circle(get_current_unit().max_movement_radius)
	pass
