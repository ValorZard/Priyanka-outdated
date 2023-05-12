extends Command

class_name DrawCardCommand

func _init(game_board : GameBoard):
	initialize(game_board)


func execute() -> bool:
	var card : CardData = current_unit.card_deck.pop_back()
	if card != null:
		current_unit.card_hand.push_back(card)
		return true
	else:
		return false

func undo() -> bool:
	var card : CardData = current_unit.card_hand.pop_back()
	if card != null:
		current_unit.card_deck.push_back(card)
		return true
	else:
		return false
