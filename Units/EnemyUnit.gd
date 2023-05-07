extends BaseUnit

class_name EnemyUnit

func _ready():
	setup_unit()
	add_to_group("enemy")

#func _process(delta):
#	$Label3D.text = str("HP: ", self.health, "\nAP: ", self.action_points)
