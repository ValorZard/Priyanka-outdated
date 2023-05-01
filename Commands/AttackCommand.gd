extends Command

class_name AttackCommand

var target : BaseUnit  #unit being attacked
var damage_dealt : int 

func _init(current_unit: BaseUnit, target: BaseUnit, damage_dealt):
	self.current_unit = current_unit
	initialized = true
	self.target = target
	self.damage_dealt = damage_dealt

func execute():
	target = current_unit.attack_area.get_nearest_unit()
	target.take_damage(damage_dealt)
	print("execute! damage_dealt: ", damage_dealt, ", target health now: ", target.health)

func undo():
	target.heal_health(damage_dealt)
	print("undo! healed amount: ", damage_dealt, ", target health now: ", target.health)
