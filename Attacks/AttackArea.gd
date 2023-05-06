extends Area3D

# Goal: Generates list of all units inside the attack area that can be attacked
class_name AttackArea

var array_of_possible_units_to_attack : Array[BaseUnit]
var owner_unit : BaseUnit

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", on_body_entered)
	self.connect("body_exited", on_body_exited)
	self.owner_unit = get_parent()


func on_body_entered(body):
	if body is BaseUnit and body != owner_unit:
		array_of_possible_units_to_attack.append(body)
	#print(array_of_possible_units_to_attack.size())

func on_body_exited(body):
	array_of_possible_units_to_attack.remove_at(array_of_possible_units_to_attack.find(body))
	#print(array_of_possible_units_to_attack.size())

# THIS FUNCTION WILL BREAK IF THERES NOTHING IN THE ARRAY
# I have no idea how to solve this problem
# gets the neartest target unit for the owner unit
func get_nearest_unit() -> BaseUnit:
	# check if this array is empty, or else the program will crash
	assert(!array_of_possible_units_to_attack.is_empty())
	#print(array_of_possible_units_to_attack)
	# set it to an impossible large number, might change later
	var closest_distance_between_target_and_owner : float = 9223372036854775807
	var closest_target_unit : BaseUnit
	for unit in array_of_possible_units_to_attack:
		if (unit.global_position - owner_unit.global_position).length() < closest_distance_between_target_and_owner:
			# probably don't want to keep killing an enemy thats already dead
			if !unit.is_dead():
				# only get unit that is on the other side.
				if (owner_unit.is_in_group("enemy") and unit.is_in_group("player")) or (owner_unit.is_in_group("player") and unit.is_in_group("enemy")):
					closest_target_unit = unit
					closest_distance_between_target_and_owner = (closest_target_unit.global_position - owner_unit.global_position).length()
			else:
				#print("this unit is dead, don't use, ", unit)
				pass
	return closest_target_unit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
