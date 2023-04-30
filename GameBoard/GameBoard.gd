extends Node3D

# GameBoard: only handles input from player
# CombatManager: handles all the meta data for the combat encounter (turn order, initiative, all that good stuff)
# CharacterUnit should only handle data relevant to that unit plus animation maybe

var mouse_button_clicked : bool = false
# actual data
#var move_to_position : Vector3 = Vector3.ZERO
# visual data
@export var character_ui_circle_width : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	$CharacterUICircle.position = $CharacterUnit.position
	$CharacterUICircle.inner_radius = distance_to_cursor
	# add a bit of a buffer to the outer radius so it isn't messed up
	$CharacterUICircle.outer_radius = distance_to_cursor + character_ui_circle_width 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# update cursor data so we can use it for movement purposes
	$Cursor.update_cursor($Camera3D, $CharacterUnit)
	# only want to actually set the position we want the unit to move to on click
	if Input.is_action_just_released("left_mouse_click"):
		$Actions/MovementCommand.execute($CharacterUnit, $Cursor.direction_to_cursor, $Cursor.distance_to_cursor)
		#render_placement_line($Cursor.position)
		render_character_ui_circle($CharacterUnit.MAX_MOVEMENT_RADIUS)
