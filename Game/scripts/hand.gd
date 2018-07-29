extends PanelContainer

signal dragged_card
signal dropped_card

onready var card_container = $"X-Sorter/Cards Container"
onready var props = $props

onready var hand_tile = load("res://Game/scenes/hand_tile.tscn")

func _ready():
	set_deck("deck4")
	draw_cards(props.deck.size())

func draw_card():
	if props.card_count >= props.max_card_count: return
	var tile = hand_tile.instance()
	tile.set_drag_forwarding(self)
	card_container.add_child(tile)
	var _id = null
	if props.deck.size() > 0:
		_id = take_first_card_from_desk()
	if _id != null:
		tile.place_card(_id)
	tile.connect("selected",self,"on_selected",[tile])

func draw_cards(n):
	for i in range(n):
		draw_card()

func take_first_card_from_desk():
	var _id = props.deck[0]
	props.deck.pop_front()
	return _id

func on_selected(tile):
	if props.last_selected != null:
		props.last_selected.turn_select()
	props.last_selected = tile

func set_deck(deck):
	var _deck = load("res://ddbb/prebuilt_decks_ddbb.gd").new().get(deck).duplicate()
	var shuffledDeck = []
	var indexDeck = range(_deck.size())
	for i in range(_deck.size()):
		randomize()
		var x = randi()%indexDeck.size()
		shuffledDeck.append(_deck[x])
		indexDeck.remove(x)
		_deck.remove(x)
	props.deck = shuffledDeck.duplicate()
	
func get_drag_data_fw(pos,hand_tile):
	if not GameGlobals.is_your_turn(): return
	var preview = TextureRect.new()
	preview.texture = load(ddbb.getImagePathByID(hand_tile.props.card_id))
	set_drag_preview(preview)
	var is_structure_big = ""
	if hand_tile.props.card_type == "structure":
		if ddbb.getByID(hand_tile.props.card_id).size == "big":
			is_structure_big = "_big"
	preview.connect("tree_exited",self,"emit_signal",["dropped_card",hand_tile.props.card_type+is_structure_big])
	emit_signal("dragged_card",hand_tile.props.card_type+is_structure_big)
	return {from="hand",card_id=hand_tile.props.card_id,drag_tile=hand_tile}