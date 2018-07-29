extends Node

var test_mode = false
var test_last_hand = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
var test_last_deck = []
var whos_turn = "blue"
var your_team = "blue"
var chara_panel_ref

func _ready():
	test_mode = true

func switch_turn():
	if whos_turn == "blue":
		whos_turn = "red"
	else:
		whos_turn = "blue"
	if test_mode:
		your_team = whos_turn

func is_your_turn():
	if whos_turn == your_team:
		return true
	else: return false

func calculate_damage(attacker,target):
	var damage
	match attacker.atks.atk_type:
		"physical":
			damage = attacker.atks.atk - floor(target.defs.def * 0.1)
		"magical":
			damage = attacker.atks.atk - floor(target.defs.mdef * 0.1)
	if damage < 0: damage = 0
	return damage

func can_place_card(card_id,tile):
	if not is_your_turn(): return false
	var card_type = ddbb.getByID(card_id).type
	match card_type:
		"chara":
			if tile.tile_info.type == "spawn" and tile.tile_info.team == your_team: return true
		"support":
			if tile.tile_info.type == "support" and tile.tile_info.team == your_team: return true
		"stadio":
			if tile.tile_info.type == "stadium": return true
		"structure":
			pass
		"band":
			pass
		"event":
			pass
		"terrain":
			pass
	return false
