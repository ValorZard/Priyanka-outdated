extends Command

class_name PlayCardCommand

var card_data : CardData
var card_button : CardButton
var attack_command : Command

func _init(game_board : GameBoard, card_data : CardData, card_button : CardButton):
	initialize(game_board)
	self.card_data = card_data
	self.card_button = card_button


func execute() -> bool:
	self.attack_command = AttackCommand.new(game_board, card_data.damage_per_attack, card_data.action_point_cost)
	if attack_command.execute():
		# get rid of card and send it to the graveyard or whatever
		current_unit.put_card_in_graveyard(card_data)
		card_button.visible = false
		game_board.log_event(str("Play card! ", card_data.card_name, " played by ", current_unit.name))
		return true
	else:
		return false
	return false

func undo() -> bool:
	if attack_command.undo():
		var old_card : CardData = current_unit.card_graveyard.pop_back()
		current_unit.card_hand.push_back(old_card)
		# the card button reference might be gone when this command undos.
		if card_button:
			card_button.visible = true
			game_board.log_event(str("undo! ", card_data.card_name, " played by ", current_unit.name))
		return true
	else:
		return false
