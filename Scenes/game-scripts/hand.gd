extends HBoxContainer

signal tile_clicked
signal button_clicked
signal notify

onready var Tile_Control = load("res://Scenes/game-scripts/tile.gd")
onready var ddbb = get_node("/root/ddbb")

var play_card_button = Button.new()
var cancel_button = Button.new()
var end_turn_button = Button.new()

var tile_array = []

var max_cards = 10
var click_order = "select"
var last_tile_clicked = null
var card_count = 0
var deck = []
var discard_pile = []
var is_playing_card = false

func _init():
	set("custom_constants/separation",0)
	size_flags_horizontal = 4
	play_card_button.text = "Play card"
	cancel_button.text = "Cancel"
	end_turn_button.text = "End turn"
	play_card_button.connect("pressed",self,"emit_signal",["button_clicked","play_card"])
	cancel_button.connect("pressed",self,"emit_signal",["button_clicked","cancel"])
	end_turn_button.connect("pressed",self,"emit_signal",["button_clicked","end_turn"])

func _ready():
	create_hand()

func tile_click_handler(tile):
	if is_playing_card: return
	match click_order:
		"select":
			if last_tile_clicked != null:
				if last_tile_clicked != tile:
					last_tile_clicked.turn_select()
					tile.turn_select()
					last_tile_clicked = tile
				elif last_tile_clicked == tile:
					tile.turn_select()
					last_tile_clicked = null
			else:
				tile.turn_select()
				last_tile_clicked = tile
		"highlight":
			if last_tile_clicked != null:
				if last_tile_clicked != tile:
					last_tile_clicked.turn_highlight()
					tile.turn_highlight()
					last_tile_clicked = tile
				elif last_tile_clicked == tile:
					tile.turn_highlight()
					last_tile_clicked = null
			else:
				tile.turn_highlight()
				last_tile_clicked = tile
	emit_signal("tile_clicked",tile)

func draw_card():
	notify("card drawed")
	if len(deck) == 0: return
	if card_count < max_cards:
		var tile = tile_array[card_count]
		var i = deck[0]
		place_card(tile,i)
		deck.pop_front()
		
func place_card(_tile,_card_id):
	if _card_id == -1: return
	_tile.card_placed = _card_id
	_tile.card_type = ddbb.getByID(_card_id).type
	var _collection = ddbb.getByID(_card_id).collection
	var _name = ddbb.getByID(_card_id).names[0]
	_tile.icon.texture = load("res://assets/collections/"+_collection+"-icos/"+_name+".png")
	card_count += 1

func remove_card(_tile):
	if _tile.card_placed == -1: return
	_tile.card_placed = -1
	_tile.card_type = ""
	_tile.icon.texture = load("res://assets/desk/empty-tile.jpg")
	card_count -= 1

func remove_all_cards():
	for tile in tile_array:
		remove_card(tile)

func remove_regroup_deselect():
	remove_card(last_tile_clicked)
	discard_pile.append(last_tile_clicked.card_placed)
	for i in range(last_tile_clicked.tile_id,max_cards):
		var tile = tile_array[i]
		var next_tile = tile_array[i+1] if i+1 < max_cards else null
		if next_tile != null:
			tile.card_placed = next_tile.card_placed
			tile.card_type = next_tile.card_type
			tile.icon.texture = next_tile.icon.texture
		else:
			tile.card_placed = -1
			tile.card_type = ""
			tile.icon.texture = load("res://assets/desk/empty-tile.jpg")
	last_tile_clicked.turn_select()
	last_tile_clicked = null

func assign_deck(_deck):
	deck = _deck.duplicate()

func get_hand_cards_id():
	var _cards_ids = []
	for tile in tile_array:
		_cards_ids.append(tile.card_placed)
	return _cards_ids

func shuffle_deck(_deck):
	var shuffledDeck = []
	var indexDeck = range(_deck.size())
	for i in range(_deck.size()):
		randomize()
		var x = randi()%indexDeck.size()
		shuffledDeck.append(_deck[x])
		indexDeck.remove(x)
		_deck.remove(x)
	return shuffledDeck
	
func notify(msg):
	emit_signal("notify",msg)

func create_hand():
	for i in range(max_cards):
		var tile = Tile_Control.new()
		tile.from = "hand"
		tile.tile_id = i
		tile.connect("tile_clicked",self,"tile_click_handler",[tile])
		tile_array.append(tile)
		add_child(tile)
	add_child(play_card_button)
	add_child(cancel_button)
	add_child(end_turn_button)
	notify("hand created")