extends Node3D

# GameBoard: only handles input from player
# EncounterData: handles all the meta data for the combat encounter (turn order, initiative, all that good stuff)
# CharacterUnit should only handle data relevant to that unit plus animation maybe
const RAY_LENGTH = 1000.0

var mouse_button_clicked : bool = false
# actual data
var move_to_position : Vector3 = Vector3.ZERO
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
func render_placement_line(cursor_position : Vector3):
	$BoxLine.position = ($CharacterUnit.position + cursor_position) / 2
	$BoxLine.width = ($CharacterUnit.position - cursor_position).length()
	$BoxLine.rotation.y = $CharacterUnit.position.angle_to(cursor_position)

# generate UI Circle around the player to show maximum distance it can go
func render_character_ui_circle(distance_to_cursor : float):
	$CharacterUICircle.position = $CharacterUnit.position
	$CharacterUICircle.inner_radius = distance_to_cursor
	# add a bit of a buffer to the outer radius so it isn't messed up
	$CharacterUICircle.outer_radius = distance_to_cursor + character_ui_circle_width 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# code taken from https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	# generate the raycast starting and ending points
	# we want to generate one every frame for UI purposes
	var camera3d := $Camera3D
	var from = camera3d.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera3d.project_ray_normal(get_viewport().get_mouse_position()) * RAY_LENGTH
	# actually create the raycast and check for overlaps with the gameboard to know where to locate the cursor
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result : Dictionary = space_state.intersect_ray(query)
	# can only actually change the cursor position if the raycast collision with the gameboard exists
	if result:
		$Cursor.position = result["position"]
		var direction_to_cursor : Vector3 = ($Cursor.position - $CharacterUnit.position).normalized()
		var distance_to_cursor : float = ($Cursor.position - $CharacterUnit.position).length()
		# don't allow the character unit to move more than it's max movement radius
		if (distance_to_cursor > $CharacterUnit.MAX_MOVEMENT_RADIUS):
			distance_to_cursor = $CharacterUnit.MAX_MOVEMENT_RADIUS
		# only want to actually set the position we want the unit to move to on click
		if Input.is_action_just_released("left_mouse_click"):
			move_to_position = $CharacterUnit.position + (direction_to_cursor * distance_to_cursor)
		#render_placement_line($Cursor.position)
		render_character_ui_circle(distance_to_cursor)
	if move_to_position != Vector3.ZERO:
		$CharacterUnit.change_position(move_to_position, delta)
