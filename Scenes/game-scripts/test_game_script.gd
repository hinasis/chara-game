extends CenterContainer

onready var my_grade = load("res://Scenes/game-scripts/grades_and_scenario.gd").new()
onready var my_desk = load("res://Scenes/game-scripts/desk.gd").new()
onready var my_hand = load("res://Scenes/game-scripts/hand.gd").new()
onready var fx_manager = load("res://Scenes/game-scripts/fx_manager.gd").new()
onready var chara_panel = load("res://Scenes/game-subscenes/CharaPanel.tscn").instance()

onready var main_popup_menu = PopupMenu.new()

var layer0 = HBoxContainer.new()
var layer1 = VBoxContainer.new()
var layer2 = VBoxContainer.new()
var waiting_for_action = false
var is_action_commanded = false

func _ready():
	add_child(layer0)
	layer0.add_child(layer1)
	layer0.add_child(layer2)
	
	layer2.rect_min_size.x = 300
	chara_panel.rect_min_size.y = 300
	layer2.add_child(chara_panel)
	GameGlobals.chara_panel_ref = chara_panel
	
	main_popup_menu.hide_on_item_selection = false
	main_popup_menu.connect("hide",self,"close_main_popup_menu")
	
	my_grade.connect("tile_clicked",self,"tile_click_handler")
	my_grade.connect("card_actioned",self,"on_card_actioned")
	my_grade.connect("notify",self,"notify")
	
	my_desk.connect("tile_clicked",self,"tile_click_handler")
	my_desk.connect("card_actioned",self,"on_card_actioned")
	my_desk.connect("notify",self,"notify")
	my_desk.connect("fx",fx_manager,"fx_request")
	
	my_hand.connect("button_clicked",self,"hand_button_click_handler")
	my_hand.connect("notify",self,"notify")
	
	layer1.add_child(main_popup_menu)
	layer1.add_child(my_grade)
	layer1.add_child(my_desk)
	layer1.add_child(my_hand)
	
	layer1.add_child(fx_manager)
	
	var deck_to_assign = []
	var deck_to_save = []
	match GameGlobals.your_team:
		"blue":
			deck_to_assign = load("res://ddbb/campain_deck_ddbb.gd").new().deck1_a.duplicate()
			deck_to_save = load("res://ddbb/campain_deck_ddbb.gd").new().deck2_a.duplicate()
		"red":
			deck_to_assign = load("res://ddbb/campain_deck_ddbb.gd").new().deck2_a.duplicate()
			deck_to_save = load("res://ddbb/campain_deck_ddbb.gd").new().deck1_a.duplicate()
	deck_to_assign = my_hand.shuffle_deck(deck_to_assign)
	GameGlobals.test_last_deck = my_hand.shuffle_deck(deck_to_save)
	my_hand.assign_deck(deck_to_assign)
	my_hand.draw_card()
	
	#test:
	my_desk.get_child(0).place_chara(0,"blue")
	my_desk.get_child(1).place_chara(1,"blue")

func tile_click_handler(tile):
	if tile.card_placed != -1:
		chara_panel.show_by_id(tile.card_placed,tile)
	if not GameGlobals.is_your_turn(): return
	if waiting_for_action: return
	match tile.card_type:
		"chara":
			notify("chara clicked")
			if tile.card_owner != GameGlobals.your_team: return
			waiting_for_action = true
			open_main_popup_menu(tile)
			

func on_card_actioned(action):
	match action:
		"placed":
			my_hand.remove_regroup_deselect()
			notify("card placed")
		"moved":
			my_desk.last_tile_clicked.remove("chara")
			notify("card moved")
		"attacked":
			notify("card attacked")
		"cancelled":
			notify("action cancelled")
	cancel_actions()

func hand_button_click_handler(button):
	if not GameGlobals.is_your_turn(): return
	match button:
		"play_card":
			if play_card():
				notify("playing card")
		"cancel":
			if waiting_for_action:
				cancel_actions()
				notify("action cancelled")
			else:
				notify("no action to cancel")
		"end_turn":
			notify("turn ended")
			cancel_actions()
			GameGlobals.switch_turn()
			if GameGlobals.test_mode:
				test_mode_switch_turn()
			my_hand.draw_card()
			

func play_card():
	if waiting_for_action: return false
	var tile = my_hand.last_tile_clicked
	if tile == null: return false
	if tile.card_placed == -1: return false
	match tile.card_type:
		"chara":
			if !my_desk.play_request("chara",tile.card_placed):
				notify("can't place the chara")
				return false
		"structure":
			if !my_desk.play_request("structure",tile.card_placed):
				notify("can't place the structure")
				return false
		"support":
			if !my_grade.play_request("support",tile.card_placed):
				notify("can't place the support")
				return false
		"stadio":
			if !my_desk.play_request("stadio",tile.card_placed):
				notify("can't place the stadio")
				return false
		"band":
			if !my_grade.play_request("band",tile.card_placed):
				notify("can't place the band")
				return false
		_:
			notify("no place for this card")
			return false
	waiting_for_action = true
	my_hand.is_playing_card = true
	return true

func main_popup_menu_command_action(item,tile):
	match tile.card_type:
		"chara":
			match item:
				0:
					if my_desk.action_request("attack",tile):
						is_action_commanded = true
					else:
						notify("can't attack")
				1:
					if my_desk.action_request("move",tile):
						is_action_commanded = true
					else:
						notify("can't move")
			main_popup_menu.hide()

func cancel_actions():
	waiting_for_action = false
	my_desk.cancel_action()
	my_grade.cancel_action()
	my_hand.is_playing_card = false

func open_main_popup_menu(tile):
	main_popup_menu.clear()
	match tile.card_type:
		"chara":
			main_popup_menu.add_item("attack")
			main_popup_menu.add_item("move")
			if tile.has_attacked == true:
				main_popup_menu.set_item_disabled(0,true)
			if tile.has_moved == true:
				main_popup_menu.set_item_disabled(1,true)
	main_popup_menu.connect("index_pressed",self,"main_popup_menu_command_action",[tile])
	main_popup_menu.add_item("cancel")
	main_popup_menu.rect_global_position = get_global_mouse_position()
	#warp_mouse(get_global_mouse_position() + Vector2(main_popup_menu.get_size().x/2,51))
	main_popup_menu.show_modal()
	notify("main card menu opened")

func close_main_popup_menu():
	main_popup_menu.disconnect("index_pressed",self,"main_popup_menu_command_action")
	if !is_action_commanded:
		cancel_actions()
	else: is_action_commanded = false
	notify("main card menu closed")

func notify(message):
	print(message)

func test_mode_switch_turn():
	var actual_deck = my_hand.deck.duplicate()
	my_hand.assign_deck(GameGlobals.test_last_deck.duplicate())
	GameGlobals.test_last_deck = actual_deck.duplicate()
	var actual_hand = my_hand.get_hand_cards_id()
	my_hand.remove_all_cards()
	for i in range(my_hand.tile_array.size()):
		my_hand.place_card(my_hand.tile_array[i], GameGlobals.test_last_hand[i])
	GameGlobals.test_last_hand = actual_hand.duplicate()
	notify("turn started")