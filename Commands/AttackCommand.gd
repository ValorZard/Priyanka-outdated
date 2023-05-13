extends Command

class_name AttackCommand

var target : BaseUnit  #unit being attacked
var damage_dealt : int 
var action_point_cost : int

func _init(game_board : GameBoard, damage_dealt : int, action_point_cost : int):
	initialize(game_board)
	#self.target = target
	self.damage_dealt = damage_dealt
	self.action_point_cost = action_point_cost

func execute():
	# first, check to see if the unit even CAN attack
	if current_unit.can_attack():
		# only allow attack if there are action points still available and if the attack doesn't put the unit into the negative
		if current_unit.action_points > 0 and (current_unit.action_points - action_point_cost >= 0):
			target = current_unit.attack_area.get_nearest_unit()
			# print(target)
			# don't attack an enemy thats already dead
			if target != null and !target.is_dead():
				target.take_damage(damage_dealt)
				current_unit.set_action_points(current_unit.get_action_points()-action_point_cost)
			else:
				return false
			game_board.log_event(str("execute! ", current_unit.name, " to ", target.name, " damage_dealt: ", damage_dealt, ", target health now: ", target.health))
			return true
		else:
			return false
	else: 
		return false

func undo():
	target.heal_health(damage_dealt)
	current_unit.set_action_points(current_unit.get_action_points() + action_point_cost)
	game_board.log_event(str("undo! " , current_unit.name, " to ", target.name, " healed amount: ", damage_dealt, ", target health now: ", target.health))
	return true
