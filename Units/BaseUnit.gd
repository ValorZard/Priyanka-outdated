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
@export var action_points : int = 3
@export var max_action_points : int = 3
var first_time := true # check if this is the unit's first turn or not

# Card stuff
@export var card_deck : Array[CardData] # all the cards in the unit's deck
@export var card_hand : Array[CardData] # the specific cards the unit current is "holding" in their hand
var card_graveyard : Array[CardData] # where discarded cards go

@export var max_amount_of_cards_in_hand := 4

# base attack information
@export var base_attack_damage : int = 1
@export var base_attack_action_point_cost : int = 1
var attack_area : AttackArea = preload("res://Attacks/AttackArea.tscn").instantiate()

#signal out_of_action_points()
# UI Stuff
var ui_circle : CSGTorus3D


# Called when the node enters the scene tree for the first time.
func setup_unit():
	attack_area = preload("res://Attacks/AttackArea.tscn").instantiate()
	add_child(attack_area)
	ui_circle = CSGTorus3D.new()
	ui_circle.visible = false
	add_child(ui_circle)

func _ready():
	setup_unit()

# note for future self, should figure out how to change this either move_and_slide or move_and_collide
# that way I can take advantage of Godot's in engine physics stuff and not run into any weird bugs
func change_position(movement_direction : Vector3, movement_distance : float):
	# don't allow character to move more than max movement radius
	if(movement_distance > self.max_movement_radius):
		movement_distance = self.max_movement_radius
	self.position += movement_direction * movement_distance

func take_damage(damage_dealt : int):
	self.health -= damage_dealt
	# handle death
	if self.health <= 0:
		handle_death()

# TODO: Figure out how death and reviving people works
func heal_health(healed_amt : int):
	if is_dead():
		#print("Unit is currently dead, attempting to revive")
		self.health += healed_amt
		# if the unit is still dead
		if is_dead():
			#print("Unit is still dead")
			pass
		else:
			#print("Unit has been revived!")
			handle_revive()
			pass
	else:
		self.health += healed_amt

func handle_death():
	self.visible = false
	pass

func handle_revive():
	self.visible = true

func can_attack() -> bool:
	#print(attack_area.array_of_possible_units_to_attack.size())
	if attack_area.array_of_possible_units_to_attack.size() <= 0:
		return false
	return true

func is_dead():
	return self.health <= 0

func get_action_points():
	return action_points

func set_action_points(action_points : int):
	self.action_points = action_points
	if self.action_points > self.max_action_points:
		self.action_points = self.max_action_points
	#if action_points <= 0:
		#out_of_action_points.emit()
		#refill_action_points()
		#print("hello, ", self.name)

func refill_action_points():
	action_points = max_action_points

func empty_action_points():
	action_points = 0

func put_card_in_graveyard(card : CardData):
	# remove card from hand
	card_hand.erase(card)
	# put it in the graveyard
	card_graveyard.push_back(card)


func _physics_process(delta):
	pass

func _process(delta):
	pass

# generate UI Circle around the unit to show maximum distance it can go
func render_ui_circle():
	ui_circle.global_position = self.global_position
	ui_circle.inner_radius = max_movement_radius
	ui_circle.outer_radius = max_movement_radius + 1
