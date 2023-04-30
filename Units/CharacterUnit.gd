extends CharacterBody3D

class_name CharacterUnit

const JUMP_VELOCITY = 4.5
const MAX_MOVEMENT_RADIUS = 10
@export var character_movement_speed : float = 7.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# character data

# animation data
var old_visual_position : Vector3 # stores the old position of the character unit model

func change_position(move_to_position : Vector3, delta):
	self.position = self.position.move_toward(move_to_position, character_movement_speed * delta)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * character_movement_speed
		velocity.z = direction.z * character_movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, character_movement_speed)
		velocity.z = move_toward(velocity.z, 0, character_movement_speed)

	move_and_slide()
