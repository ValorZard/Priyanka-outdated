extends Button

class_name CardButton

@export var card_data : CardData

var game_board : GameBoard
var owner_unit : BaseUnit

#signal card_played(card_data)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("button_down", play_card)

func setup(owner_unit : BaseUnit, card_data : CardData, game_board : GameBoard):
	self.owner_unit = owner_unit
	self.card_data = card_data
	self.game_board = game_board
	$CardName.text = card_data.card_name
	$CardStats.text = str("AP: ", card_data.action_point_cost, " DMG: ", card_data.damage_per_attack)
	$CardDescription.text = card_data.description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_card():
	var play_card_cmd : PlayCardCommand = PlayCardCommand.new(game_board, card_data, self)
	if play_card_cmd.execute():
		game_board.add_command(play_card_cmd)
