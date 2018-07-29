extends CenterContainer

signal tile_clicked

onready var ddbb = get_node("/root/ddbb")

var highlight_shader = ColorRect.new()
var border = TextureRect.new()
var border_default_texture_path = "res://assets/desk/white_60_x_60.png"
var background = TextureRect.new()
var background_empty_texture_path = "res://assets/desk/empty-tile.jpg"
var icon = TextureRect.new()
var selected = false
var highlighted = false
var select_tween = Tween.new()
var highlight_tween = Tween.new()
var occuped = false
var terrain_occuped = false
var event_occuped = false
var card_owner = ""
var terrain_card_owner = ""
var event_card_owner = ""
var card_placed = -1
var terrain_card_placed = -1
var event_card_placed = -1
var chara_effect = []
var terrain_effects = []
var event_effects = []
var support_effects = []
var has_insides = false
var insides_capacity = 0
var event_duration = 0
var card_type = ""
var from = ""
var row = -1
var column = -1
var team = ""
var type = ""
var tile_id = -1
var is_big = -1
var has_attacked = false
var attack_count = 0
var current_attack_count = 0
var has_moved = false
var move_count = 0
var current_move_count = 0
var damage_count = 0
var soul_count = 0

func _init():
	var d = {bmax=62,tmax=56,imax=50}
	rect_min_size = Vector2(d.bmax,d.bmax)
	highlight_shader.rect_min_size = Vector2(d.bmax,d.bmax)
	highlight_shader.color = Color(0,0,0)
	highlight_shader.material = ShaderMaterial.new()
	highlight_shader.material.shader = load("res://assets/basic_color_rect.shader")
	highlight_shader.visible = false
	highlight_shader.mouse_filter = MOUSE_FILTER_IGNORE
	border.texture = load(border_default_texture_path)
	border.expand = true
	border.stretch_mode = TextureRect.STRETCH_TILE
	border.rect_min_size = Vector2(d.bmax,d.bmax)
	border.modulate = Color(1,1,1,.01)
	border.rect_pivot_offset = Vector2(d.bmax/2,d.bmax/2)
	background.texture = load(background_empty_texture_path)
	background.expand = true
	background.stretch_mode = TextureRect.STRETCH_TILE
	background.rect_min_size = Vector2(d.tmax,d.tmax)
	icon.expand = true
	icon.stretch_mode = TextureRect.STRETCH_TILE
	icon.rect_min_size = Vector2(d.imax,d.imax)
	select_tween.connect("tween_completed",select_tween,"remove")
	highlight_tween.connect("tween_completed",highlight_tween,"remove")

func _ready():
	add_child(border)
	add_child(background)
	add_child(icon)
	add_child(select_tween)
	add_child(highlight_tween)
	add_child(highlight_shader)
	self.connect("gui_input",self,"on_click_handler")

func on_click_handler(ev):
	if ev is InputEventMouseButton and ev.is_action_pressed("mouse_left"):
		emit_signal("tile_clicked")

func place_chara(_id,_owner,_effects=[]):
	card_placed = _id
	card_type = "chara"
	card_owner = _owner
	chara_effect = _effects.duplicate()
	occuped = true
	set_icon_texture(_id)

func place_support(_id,_owner,_effects=[]):
	card_placed = _id
	card_type = "support"
	card_owner = _owner
	support_effects = _effects.duplicate()
	occuped = true
	set_icon_texture(_id)

func place_structure(_id,_insides,_owner):
	card_placed = _id
	card_type = "structure"
	card_owner = _owner
	if _insides != 0:
		has_insides = true
		insides_capacity = _insides
	occuped = true
	set_icon_texture(_id)

func place_stadio(_id):
	card_placed = _id
	card_type = "stadio"
	occuped = true
	set_icon_texture(_id)

func place_band(_id,_owner):
	card_placed = _id
	card_type = "band"
	card_owner = _owner
	occuped = true
	set_icon_texture(_id)

func place_terrain(_id,_owner,_effects=[]):
	terrain_card_placed = _id
	terrain_card_owner = _owner
	terrain_effects = _effects.duplicate()
	terrain_occuped = true

func place_event(_id,_owner,_duration,_effects=[]):
	event_card_placed = _id
	event_card_owner = _owner
	event_effects = _effects.duplicate()
	event_duration = _duration
	event_occuped = true

func damage(dmg):
	damage_count += dmg
	if is_dead():
		remove(card_type)
	return true

func is_dead():
	var max_hp = ddbb.getByID(card_placed).hp_sp.hp
	if max_hp - damage_count <= 0:
		return true
	else:
		return false

func remove(what=""):
	if what == "chara" or what == "structure" or  what == "all":
		card_placed = -1
		card_type = ""
		card_owner = ""
		occuped = false
		if what == "chara" or what == "all":
			chara_effect = []
		if what == "structure" or what == "all":
			has_insides = false
			insides_capacity = 0
		icon.texture = load("res://assets/desk/empty-tile.jpg")
	if what == "terrain" or what == "all":
		terrain_card_placed = -1
		terrain_card_owner = ""
		terrain_effects = []
		terrain_occuped = false
	if what == "event" or what == "all":
		event_card_placed = -1
		event_card_owner = ""
		event_effects = []
		event_duration = 0
		event_occuped = false

func turn_highlight():
	if !highlighted:
		turn_highlight_on()
	elif highlighted:
		turn_highlight_off()
func turn_highlight_on():
	highlighted = true
	var color = Color(.9,.8,.2,.7)
	if occuped: color = Color(.6,0,.8,.5) #so it's a target
	highlight_tween.interpolate_property(border,"modulate",border.modulate,color,.2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	highlight_tween.interpolate_property(border,"rect_scale",Vector2(.8,.8),Vector2(1,1),.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	highlight_tween.start()
	highlight_shader.visible = true
	#border.modulate = Color(.8,.8,0,.5)
func turn_highlight_off():
	if select_tween.is_active(): select_tween.remove_all()
	if highlight_tween.is_active(): highlight_tween.remove_all()
	highlighted = false
	border.rect_scale = Vector2(1,1)
	border.modulate = Color(1,1,1,.01)
	highlight_shader.visible = false

func turn_select():
	if !selected:
		turn_select_on()
	else:
		turn_select_off()
func turn_select_on():
	selected = true
	var color = Color(0,6,0,.5)
	match card_owner:
		"blue":
			color = Color(.2,.2,1,.5)
		"red":
			color = Color(1,.2,.2,.5)
	select_tween.interpolate_property(border,"modulate",border.modulate,color,.2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	select_tween.interpolate_property(border,"rect_scale",Vector2(.8,.8),Vector2(1,1),.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	select_tween.start()
	#border.modulate = color
func turn_select_off():
	if select_tween.is_active(): select_tween.remove_all()
	if highlight_tween.is_active(): highlight_tween.remove_all()
	selected = false
	border.rect_scale = Vector2(1,1)
	border.modulate = Color(1,1,1,.01)

func set_icon_texture(_id):
	var _collection = ddbb.getByID(_id).collection
	var _name = ddbb.getByID(_id).names[0]
	if is_big == -1 or ddbb.getByID(_id).type != "structure":
		
		icon.texture = load("res://assets/collections/"+_collection+"-icos/"+_name+".png")
	else:
		icon.texture = load("res://assets/collections/"+_collection+"-icos/"+_name+"_"+str(is_big)+".png")