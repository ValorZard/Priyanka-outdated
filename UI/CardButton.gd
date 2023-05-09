extends Button

class_name CardButton

var card_data : CardData = preload("res://Cards/CardData.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str("Attack Points: ", card_data.attack_point_cost, "\n", card_data.description)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
