extends Node3D


const RAY_LENGTH = 1000.0

var mouse_button_clicked : bool = false

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
	# Print the size of the viewport.
	# print("Viewport Resolution is: ", get_viewport_rect().size)
	# code taken from https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		mouse_button_clicked = true
	else:
		mouse_button_clicked = false
	#$Cursor.position = Vector3(-5, 5, -5)
	#print($Cursor.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if mouse_button_clicked:
		# generate the raycast starting and ending points
		var camera3d = $Camera3D
		var from = camera3d.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera3d.project_ray_normal(get_viewport().get_mouse_position()) * RAY_LENGTH
		print("from: ", from, " to: " , to)
		# actually create the raycast and check for overlaps
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result : Dictionary = space_state.intersect_ray(query)
		if result:
			$Cursor.position = result["position"]
