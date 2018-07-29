extends CenterContainer

signal tile_clicked

onready var tile_props = $tile_props
onready var tile_info = $tile_info
onready var tile_status = $tile_status

onready var portrait = $Portrait

export var border_color = Color(1,1,1)

func _ready():
	$Background.self_modulate = border_color
	self.connect("gui_input",self,"on_tile_clicked")

func on_tile_clicked(ev):
	if ev.is_action_pressed("mouse_left"):
		emit_signal("tile_clicked")
		
		#-- test info:
		var test_info = false
		if test_info:
			prints(tile_info.from, "row: " + str(tile_info.row), " col: " + str(tile_info.column), " id: " + str(tile_info.tile_id))
			print(tile_info.team + " ", tile_info.type, ", is big: " + str(tile_info.is_big == 1))
			print("neighbours:")
			prints(tile_info.sr_occupeds[0],tile_info.sr_occupeds[1],tile_info.sr_occupeds[2])
			prints(tile_info.sr_occupeds[3],"X",tile_info.sr_occupeds[4])
			prints(tile_info.sr_occupeds[5],tile_info.sr_occupeds[6],tile_info.sr_occupeds[7])

func place_card(_id,_owner,_type,_effects={}):
	tile_status.card_placed = _id
	tile_status.card_owner = _owner
	tile_status.card_type = _type
	tile_status.occuped = true
	match _type:
		"chara":
			tile_props.chara_effects = _effects
		"support":
			tile_props.support_effects= _effects
		"structure":
			var insides = ddbb.getByID(_id).insides
			if insides != 0:
				tile_props.has_insides = true
				tile_props.insides_capacity = insides
		"stadio":
			tile_props.stadio_effects = _effects
		"band":
			tile_props.band_effects = _effects
			tile_props.band_duraction = ddbb.getByID(_id).duration
		_: return false
	if _type == "structure" and ddbb.getByID(_id).size == "big":
		set_portrait(tile_info.is_big)
	else:
		set_portrait()
	return true

func place_terrain(_id,_owner,_effects={}):
	tile_status.terrain_placed = _id
	tile_status.terrain_owner = _owner
	tile_status.terrain_ocupped = true
	tile_props.terrain_effects = _effects
	set_background()
	return true

func place_event(_id,_owner,_duration,_effects={}):
	tile_status.event_placed = _id
	tile_status.event_owner = _owner
	tile_status.event_ocupped = true
	tile_props.event_effects = _effects
	tile_props.event_duration = _duration
	return true

func remove(what):
	var type_0 = ["chara","support","structure","stadio","band"]
	if what in type_0:
		tile_status.card_placed = -1
		tile_status.card_type = ""
		tile_status.card_owner = ""
		tile_status.occuped = false
		$Portrait.texture = null
		match what:
			"chara":
				tile_props.chara_effects = {}
				tile_props.is_pet = false
			"support":
				tile_props.support_effects = {}
			"structure":
				tile_props.has_insides = false
				tile_props.insides_capacity = 0
			"band":
				tile_props.band_effects = {}
				tile_props.band_duraction = 0
			"stadio":
				tile_props.stadio_effects = {}
	if what == "terrain":
		tile_status.terrain_placed = -1
		tile_status.terrain_owner = ""
		tile_status.terrain_ocupped = false
		tile_props.terrain_effects = {}
	if what == "event":
		tile_status.event_placed = -1
		tile_status.event_owner = ""
		tile_status.event_ocupped = false
		tile_props.event_effects = {}
		tile_props.event_duration = 0

func add_effects(_type,_effects):
	match _type:
		"chara": merge_dicts(tile_props.chara_effects,_effects)
		"support": merge_dicts(tile_props.support_effects,_effects)
		"band": merge_dicts(tile_props.band_effects,_effects)
		"stadio": merge_dicts(tile_props.stadio_effects,_effects)
		"terrain": merge_dicts(tile_props.terrain_effects,_effects)
		"event": merge_dicts(tile_props.event_effects,_effects)

func damage(dmg):
	tile_props.hp_damage_count += dmg
	if is_dead():
		remove(tile_status.card_type)
	return true # can be damaged

func is_dead():
	var max_hp = ddbb.getByID(tile_status.card_placed).hp_sp.hp
	if max_hp - tile_props.hp_damage_count <= 0:
		return true
	else:
		return false

func turn_select():
	if not tile_status.selected:
		turn_select_on()
	else:
		turn_select_off()

func turn_select_on():
	tile_status.selected = true
	#-- fancy:
	var color = ddbb.get_custom_color(tile_status.card_owner)
	color = Color(color.r,color.g,color.b,0.0) # preventing overriding select texture alpha
	$"Select Aura".material.set("shader_param/color_sum",color)
	$"Select Aura".visible = true

func turn_select_off():
	tile_status.selected = false
	#-- fancy
	$"Select Aura".visible = false

func turn_highlight():
	if not tile_status.highlited:
		turn_highlight_on()
	else:
		turn_highlight_off()

func turn_highlight_on():
	tile_status.highlited = true
	#-- fancy:
	$"Highlight Shine".visible = true

func turn_highlight_off():
	tile_status.highlited = false
	#-- fancy:
	$"Highlight Shine".visible = false

func set_background():
	$Background.texture = load(ddbb.getImagePathByID(tile_status.card_placed,"bg"))

func set_portrait(big_idx=0):
	$Portrait.texture = load(ddbb.getImagePathByID(tile_status.card_placed,"ico",big_idx))

func merge_dicts(dict,to_dict):
	for key in dict.keys():
		if key in to_dict.keys():
			dict[key] = to_dict[key]
	for key in to_dict.keys():
		if not key in dict:
			dict[key] = to_dict[key]
















