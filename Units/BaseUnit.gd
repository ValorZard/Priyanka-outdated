extends CharacterBody3D

# all other unit classes, both character and enemy units, all inherit from Base Unit
class_name BaseUnit 

const JUMP_VELOCITY = 4.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Unit Data
@export var health : int = 10
@export var movement_speed : float = 7.5
@export var max_movement_radius : float = 10 # maximum distance this unit can move in one turn in meters

# note for future self, should figure out how to change this either move_and_slide or move_and_collide
# that way I can take advantage of Godot's in engine physics stuff and not run into any weird bugs
func change_position(movement_direction : Vector3, movement_distance : float):
	# don't allow character to move more than max movement radius
	if(movement_distance > self.max_movement_radius):
		movement_distance = self.max_movement_radius
	self.position += movement_direction * movement_distance

func take_damage(damage_dealt : int):
	self.health -= damage_dealt

func heal_health(healed_amt : int):
	self.health += healed_amt

func _physics_process(delta):
	pass
