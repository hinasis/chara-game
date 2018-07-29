extends VBoxContainer

signal selected

onready var head = $"Head Panel"
onready var body = $"Body Panel"
onready var head_style = head.get("custom_styles/panel")
onready var body_style = body.get("custom_styles/panel")
onready var props = $props
onready var icon = $"Body Panel/Portrait"
onready var type_label = $"Head Panel/Type Label"

var head_style_normal = load("res://Game/styles/hand_tile_head_normal.tres")
var head_style_selected = load("res://Game/styles/hand_tile_head_selected.tres")
var body_style_normal = load("res://Game/styles/hand_tile_body_normal.tres")
var body_style_selected = load("res://Game/styles/hand_tile_body_selected.tres")

func _ready():
	connect("gui_input",self,"on_clicked")

func on_clicked(ev):
	if ev.is_action_pressed("mouse_left"):
		turn_select()
		emit_signal("selected")

func place_card(_id):
	props.card_id = _id
	props.card_type = ddbb.getByID(_id).type
	props.ocupped = true
	props.cost = ddbb.getByID(_id).cost.duplicate()
	type_label.text = props.card_type.to_upper()
	set_portrait()

func remove_card():
	props.card_id = -1
	props.card_type = ""
	props.ocupped = false
	props.cost = props.zero_cost.duplicate()
	type_label.text = "empty"
	remove_portrait()

func turn_select():
	if not props.selected:
		turn_select_on()
	else:
		turn_select_off()

func turn_select_on():
	props.selected = true
	#-- fancy:
	head.set("custom_styles/panel",head_style_selected)
	body.set("custom_styles/panel",body_style_selected)

func turn_select_off():
	props.selected = false
	#-- fancy:
	head.set("custom_styles/panel",head_style_normal)
	body.set("custom_styles/panel",body_style_normal)

func set_portrait():
	icon.texture = load(ddbb.getImagePathByID(props.card_id))

func remove_portrait():
	icon.texture = load(ddbb.getDefaultImagePath("ico"))