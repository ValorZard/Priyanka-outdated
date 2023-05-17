extends Resource

class_name CardData

enum CardType {ATTACK, ABILITY}

@export var card_name : String
@export var card_type : CardType
@export var action_point_cost: int
@export var damage_per_attack : int
@export var attacks_per_unit : int
@export var number_of_units_affected_by_card : int
@export var description : String


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(card_name := "", card_type := CardType.ATTACK, action_point_cost := 0, damage_per_attack := 0, 
	attacks_per_unit := 1, number_of_units_affected_by_card := 1, description := "lorem ipsum"):
	self.card_name = card_name
	self.action_point_cost = action_point_cost
	self.damage_per_attack = damage_per_attack
	self.attacks_per_unit = attacks_per_unit
	self.number_of_units_affected_by_card = number_of_units_affected_by_card
	self.description = description
