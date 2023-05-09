extends Button

class_name CardButton

@export var card_data : CardData = preload("res://Cards/CardData.tres")

var game_board : GameBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str("Action Points: ", card_data.action_point_cost, "\n", card_data.description)
	self.connect("button_down", play_card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_card():
	game_board.do_attack(card_data.attack_damage, card_data.action_point_cost)
