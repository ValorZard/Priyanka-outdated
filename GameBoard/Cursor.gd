extends Sprite3D

class_name Cursor

# data variables
var direction_to_cursor : Vector3
var distance_to_cursor : float

# raycast data
const RAY_LENGTH = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# update cursor data so we can use it for movement purposes
func update_cursor(camera3d : Camera3D, current_player_unit : PlayerUnit):
	# code taken from https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	# generate the raycast starting and ending points
	# we want to generate one every frame for UI purposes
	var from = camera3d.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera3d.project_ray_normal(get_viewport().get_mouse_position()) * RAY_LENGTH
	# actually create the raycast and check for overlaps with the gameboard to know where to locate the cursor
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result : Dictionary = space_state.intersect_ray(query)
	# can only actually change the cursor position if the raycast collision with the gameboard exists
	if result:
		self.position = result["position"]
		# figure out distance and direction from current character unit TO cursor
		self.direction_to_cursor = (self.position - current_player_unit.position).normalized()
		self.distance_to_cursor = (self.position - current_player_unit.position).length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
