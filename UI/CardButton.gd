extends Button

class_name CardButton

@export var card_data : CardData

var game_board : GameBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardName.text = card_data.card_name
	$CardStats.text = str("AP: ", card_data.action_point_cost, " DMG: ", card_data.attack_damage)
	$CardDescription.text = card_data.description
	self.connect("button_down", play_card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_card():
	game_board.do_attack(card_data.attack_damage, card_data.action_point_cost)
