extends Node3D

class_name GameBoard

# GameBoard: only handles input from player
# CombatManager: handles all the meta data for the combat encounter (turn order, initiative, all that good stuff)
# CharacterUnit should only handle data relevant to that unit plus animation maybe

var mouse_button_clicked : bool = false
# actual data
#var move_to_position : Vector3 = Vector3.ZERO
# visual data
@export var character_ui_circle_width : float = 1
var ui_manager : UIManager

var command_array : Array
var current_unit : BaseUnit

# Called when the node enters the scene tree for the first time.
func _ready():
	current_unit = $CharacterUnit
	ui_manager = $UIManager

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		pass
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		pass

# generate "line" between cursor and player for UI purposes
# NOTE: Doesn't currently work properly, rotation is a bit jank
#func render_placement_line(cursor_position : Vector3):
#	$BoxLine.position = ($CharacterUnit.position + cursor_position) / 2
#	$BoxLine.width = ($CharacterUnit.position - cursor_position).length()
#	$BoxLine.rotation.y = $CharacterUnit.position.angle_to(cursor_position)

# generate UI Circle around the player to show maximum distance it can go
func render_character_ui_circle(distance_to_cursor : float):
	$CharacterUICircle.position = current_unit.position
	$CharacterUICircle.inner_radius = distance_to_cursor
	# add a bit of a buffer to the outer radius so it isn't messed up
	$CharacterUICircle.outer_radius = distance_to_cursor + character_ui_circle_width 

func log_event(message : String):
	ui_manager.print_message(message)

# logic functions
func undo_command():
	if !command_array.is_empty():
		command_array.pop_back().undo()

func do_attack():
	if current_unit.can_attack():
		var attack_command := AttackCommand.new(self, $EnemyUnit, 1)
		if attack_command.execute():
			command_array.push_back(attack_command)

func do_movement(direction : Vector3, distance : float):
	var movement_command := MovementCommand.new(self, direction, distance)
	if movement_command.execute():
		command_array.push_back(movement_command)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# GAME LOOP -> update every single unit in the field, and let the player control the player units
	# update cursor data so we can use it for movement purposes
	ui_manager.cursor.update_cursor($Camera3D, current_unit)
	ui_manager.get_input()
	# render UI stuff
	#render_placement_line($Cursor.position)
	render_character_ui_circle(current_unit.max_movement_radius)
