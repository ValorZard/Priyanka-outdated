extends Resource

class_name CardData

enum CardType {ATTACK, ABILITY}

@export var card_name : String
@export var card_type : CardType
@export var action_point_cost: int
@export var attack_damage : int
@export var description : String


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(card_name = "", card_type = CardType.ATTACK, action_point_cost = 0, attack_damage = 0, description = "lorem ipsum"):
	self.card_name = card_name
	self.action_point_cost = action_point_cost
	self.attack_damage = attack_damage
	self.description = description
