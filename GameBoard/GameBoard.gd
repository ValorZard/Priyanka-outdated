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

# Called when the node enters the scene tree for the first time.
func _ready():
	current_unit_index = 0
	# set up all the units in initative order
	for node in get_children():
		if node is BaseUnit:
			units_in_initative_order.append(node)
	#print(units_in_initative_order)
	get_current_unit().enable_unit()

# generate "line" between cursor and player for UI purposes
# NOTE: Doesn't currently work properly, rotation is a bit jank
#func render_placement_line(cursor_position : Vector3):
#	$BoxLine.position = ($CharacterUnit.position + cursor_position) / 2
#	$BoxLine.width = ($CharacterUnit.position - cursor_position).length()
#	$BoxLine.rotation.y = $CharacterUnit.position.angle_to(cursor_position)

func log_event(message : String):
	event_queue.push_front(message)
	event_label.text = ""
	for event in event_queue:
		event_label.text += event + "\n"

# logic functions
func get_current_unit():
	return units_in_initative_order[current_unit_index]

func undo_command():
	if !command_array.is_empty():
		command_array.pop_back().undo()

# make the current unit controlled by the game board attack
func do_attack(damage_dealt : int, action_point_cost : int) -> bool:
	if get_current_unit().can_attack():
		var attack_command := AttackCommand.new(self, $EnemyUnit, damage_dealt, action_point_cost)
		if attack_command.execute():
			command_array.push_back(attack_command)
			return true
	return false

# make the current unit controlled by the game board move
func do_movement(direction : Vector3, distance : float):
	var movement_command := MovementCommand.new(self, direction, distance)
	if movement_command.execute():
		command_array.push_back(movement_command)

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
func go_to_next_unit():
	# clean up stuff with the current unit
	get_current_unit().disable_unit()
	#go to next unit. if reached the end, go back to the start
	current_unit_index += 1
	if current_unit_index >= units_in_initative_order.size():
		current_unit_index = 0
	# if the new unit we're on is dead, move on to the next one
	if get_current_unit().is_dead() and !check_if_one_side_won():
		go_to_next_unit()
	# set up new unit
	get_current_unit().enable_unit()
	#print("moving on to next unit : ", current_unit_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# GAME LOOP -> update every single unit in the field, and let the player control the player units
	# update cursor data so we can use it for movement purposes
	# render UI stuff
	#render_placement_line($Cursor.position)
	#render_character_ui_circle(get_current_unit().max_movement_radius)
	pass
