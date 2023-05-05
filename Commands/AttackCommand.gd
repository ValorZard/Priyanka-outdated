extends Command

class_name AttackCommand

var target : BaseUnit  #unit being attacked
var damage_dealt : int 

func _init(game_board : GameBoard, target: BaseUnit, damage_dealt):
	initialize(game_board)
	self.target = target
	self.damage_dealt = damage_dealt

func execute():
	# only allow attack if there are action points still available
	if current_unit.action_points > 0:
		target = current_unit.attack_area.get_nearest_unit()
		#print(target)
		# don't attack an enemy thats already dead
		if target != null and !target.is_dead():
			target.take_damage(damage_dealt)
			current_unit.set_action_points(current_unit.get_action_points()-1)
		else:
			return false
		game_board.log_event(str("execute! ", target.name, " damage_dealt: ", damage_dealt, ", target health now: ", target.health))
		return true
	else:
		return false

func undo():
	target.heal_health(damage_dealt)
	current_unit.set_action_points(current_unit.get_action_points()+1)
	game_board.log_event(str("undo! " , target.name, " healed amount: ", damage_dealt, ", target health now: ", target.health))
	return true
