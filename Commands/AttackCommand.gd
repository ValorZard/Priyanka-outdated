extends Command

class_name AttackCommand

var targets : Array[BaseUnit]  #unit being attacked
var damage_dealt : int 
var action_point_cost : int
var attacks_per_unit: int
var number_of_units_attacked : int 

func _init(game_board : GameBoard, damage_dealt : int, action_point_cost : int, attacks_per_unit: int = 1, number_of_units_attacked : int = 1):
	initialize(game_board)
	#self.target = target
	self.damage_dealt = damage_dealt
	self.action_point_cost = action_point_cost
	self.attacks_per_unit = attacks_per_unit
	self.number_of_units_attacked = number_of_units_attacked

func execute():
	# first, check to see if the unit even CAN attack
	if current_unit.can_attack():
		# only allow attack if there are action points still available and if the attack doesn't put the unit into the negative
		if current_unit.action_points > 0 and (current_unit.action_points - action_point_cost >= 0):
			# only get target if there are any units near by
			if current_unit.attack_area.get_nearest_units().size() > 0:
				targets = current_unit.attack_area.get_nearest_units().slice(0, number_of_units_attacked)
			print(targets)
			# don't attack an enemy thats already dead
			if targets.size() > 0:
				current_unit.set_action_points(current_unit.get_action_points()-action_point_cost)
				print(current_unit.action_points)
				for target in targets:
					# do all the multihits per target
					for i in range(0, attacks_per_unit):
						target.take_damage(damage_dealt)
						game_board.log_event(str("execute! ", current_unit.name, " to ", target.name, " damage_dealt: ", damage_dealt, ", target health now: ", target.health))
				return true
		else:
			return false
	else: 
		return false

func undo():
	current_unit.set_action_points(current_unit.get_action_points() + action_point_cost)
	for target in targets:
		for i in range(0, attacks_per_unit):
			target.heal_health(damage_dealt)
			game_board.log_event(str("undo! " , current_unit.name, " to ", target.name, " healed amount: ", damage_dealt, ", target health now: ", target.health))
	return true
