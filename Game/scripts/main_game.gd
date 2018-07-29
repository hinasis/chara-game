extends HBoxContainer

onready var MainDesk = $"Desk/Main Desk"
onready var Hand = $Desk/Hand
onready var my_tile = load("res://Game/scenes/tile.tscn").instance()

onready var FXM = load("res://Game/FX_manager.gd").new()

var is_dragging_card = false
var current_target_group = ""

func _ready():
	add_child(FXM)
	
	Hand.connect("dragged_card",self,"on_hand_dragged_card")
	Hand.connect("dropped_card",self,"on_hand_dropped_card")
	MainDesk.connect("dragged_card",self,"on_desk_dragged_card")
	MainDesk.connect("dropped_card",self,"on_desk_dropped_card")
	MainDesk.connect("attacked",self,"on_attack")
	MainDesk.connect("card_placed",self,"on_card_placed")
	
	var can_drop_cursor_img = load("res://assets/misc/custom cursors/can_drop.png")
	var forbidden_cursor_img = load("res://assets/misc/custom cursors/forbidden.png")
	Input.set_custom_mouse_cursor(can_drop_cursor_img,7)
	Input.set_custom_mouse_cursor(forbidden_cursor_img,8)
	
func on_hand_dragged_card(card_type):
	MainDesk.highlight_target_group_for(card_type)

func on_hand_dropped_card(card_type):
	MainDesk.highlight_target_group_for(card_type)

func on_desk_dragged_card():
	pass
	
func on_desk_dropped_card():
	pass

func on_attack(atk_tile,def_tile):
	var atk_card_id = atk_tile.tile_status.card_placed
	var def_card_id = def_tile.tile_status.card_placed
	var atk_card = ddbb.getByID(atk_card_id)
	var def_card = ddbb.getByID(def_card_id)
	var damage = GameGlobals.calculate_damage(atk_card,def_card)
	FXM.fx_attack(atk_tile,def_tile,damage,1)

func on_card_placed(on_tile):
	FXM.fx_card_placed(on_tile)