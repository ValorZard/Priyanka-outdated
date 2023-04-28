extends Node3D


const RAY_LENGTH = 1000.0

var mouse_button_clicked : bool = false
var current_cursor_position : Vector3 = Vector3.ZERO
var character_movement_speed : float = 7.5

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# code taken from https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	# generate the raycast starting and ending points
	# we want to generate one every frame for UI purposes
	var camera3d = $Camera3D
	var from = camera3d.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera3d.project_ray_normal(get_viewport().get_mouse_position()) * RAY_LENGTH
	# actually create the raycast and check for overlaps
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result : Dictionary = space_state.intersect_ray(query)
	# can only actually change the cursor position if the raycast collision with the gameboard exists
	if result:
		$Cursor.position = result["position"]
		# only want to actually set the cursor position on click
		if Input.is_action_just_released("left_mouse_click"):
			current_cursor_position = result["position"]
		# generate "line" between cursor and player for UI purposes
		$BoxLine.position = ($CharacterUnit.position + result["position"]) / 2
		$BoxLine.width = ($CharacterUnit.position - result["position"]).length()
		$BoxLine.rotation.y = $CharacterUnit.position.angle_to(result["position"])
	
	if current_cursor_position != Vector3.ZERO:
		$CharacterUnit.position = $CharacterUnit.position.move_toward(current_cursor_position, character_movement_speed * delta)
