extends Button

class_name CardButton

@export var card_data : CardData

var game_board : GameBoard
var owner_unit : BaseUnit
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("button_down", play_card)

func setup(owner_unit : BaseUnit, card_data : CardData, game_board : GameBoard):
	self.owner_unit = owner_unit
	self.card_data = card_data
	self.game_board = game_board
	$CardName.text = card_data.card_name
	$CardStats.text = str("AP: ", card_data.action_point_cost, " DMG: ", card_data.attack_damage)
	$CardDescription.text = card_data.description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_card():
	if game_board.do_attack(card_data.attack_damage, card_data.action_point_cost):
		# get rid of card and send it to the graveyard or whatever
		owner_unit.card_hand.erase(card_data)
		self.queue_free()
