extends Node

onready var chara_ddbb = load("res://ddbb/chara_ddbb.gd").new().ca
onready var support_ddbb = load("res://ddbb/support_ddbb.gd").new().sa
onready var stadio_ddbb = load("res://ddbb/stadio_ddbb.gd").new().sa
onready var structure_ddbb = load("res://ddbb/structure_ddbb.gd").new().sa
onready var band_ddbb = load("res://ddbb/band_ddbb.gd").new().ba
onready var pet_ddbb = load("res://ddbb/pet_ddbb.gd").new().pet_owners


var totalIDs = 0
var nextID = 0
var lastID = -1

var full_ddbb = []
var charas = []
var supports = []
var stadios = []
var structures = []
var bands = []

func _ready():
	for c in chara_ddbb:
		createCharacter(c)
	for s in support_ddbb:
		createSupporter(s)
	for s in stadio_ddbb:
		createStadium(s)
	for s in structure_ddbb:
		createStructure(s)
	for b in band_ddbb:
		createBand(b)
	full_ddbb = [charas,supports,stadios,structures,bands]

func createCharacter(c):
	var chara = c.duplicate()
	chara.id = nextID
	chara.type = "chara"
	nextID += 1
	lastID += 1
	totalIDs += 1
	charas.append(chara)

func createSupporter(s):
	var support = s.duplicate()
	support.id = nextID
	support.type = "support"
	nextID += 1
	lastID += 1
	totalIDs += 1
	supports.append(support)

func createStadium(s):
	var stadio = s.duplicate()
	stadio.id = nextID
	stadio.type = "stadio"
	nextID += 1
	lastID += 1
	totalIDs += 1
	stadios.append(stadio)

func createStructure(s):
	var structure = s.duplicate()
	structure.id = nextID
	structure.type = "structure"
	nextID += 1
	lastID += 1
	totalIDs += 1
	structures.append(structure)

func createBand(b):
	var band = b.duplicate()
	band.id = nextID
	band.type = "band"
	nextID += 1
	lastID += 1
	totalIDs += 1
	bands.append(band)

func getByID(id):
	if id < 0: return 
	var prev_size = 0
	var temp_size = full_ddbb[0].size()
	# search in charas
	if prev_size <= id and id < temp_size:
		return full_ddbb[0][id - prev_size]
	prev_size = temp_size
	temp_size = temp_size + full_ddbb[1].size()
	# search in supporters
	if prev_size <= id and id < temp_size:
		return full_ddbb[1][id - prev_size]
	prev_size = temp_size
	temp_size = temp_size + full_ddbb[2].size()
	# search in stadios
	if prev_size <= id and id < temp_size:
		return full_ddbb[2][id - prev_size]
	prev_size = temp_size
	temp_size = temp_size + full_ddbb[3].size()
	# search in structures
	if prev_size <= id and id < temp_size:
		return full_ddbb[3][id - prev_size]
	prev_size = temp_size
	temp_size = temp_size + full_ddbb[4].size()
	# search in bands
	if prev_size <= id and id < temp_size:
		return full_ddbb[4][id - prev_size]

func listCardsByID():
	for card_type in full_ddbb:
		for card in card_type:
			print(card.names[0]," - ",card.id)
			

func getImagePathByID(card_id,what="ico",big_index=0):
	var card = ddbb.getByID(card_id)
	var path_to_collection = "res://assets/collections/"+card.collection
	var str_big_index = "_"+str(big_index)
	if str_big_index == "_0": str_big_index = ""
	match what:
		"ico": return path_to_collection+"-icos/"+card.names[0]+str_big_index+".png"
		"atk": return path_to_collection+"-icos/"+card.names[0]+"_atk.png"
		"def": return path_to_collection+"-icos/"+card.names[0]+"_def.png"
		"bg": return path_to_collection+"-terrain/"+card.names[0]+".png"

func getDefaultImagePath(for_what):
	match for_what:
		"ico": return load("res://assets/desk/default_ico.png")
		"terrain": return load("res://assets/desk/default_terrain.png")

func getDeskTileTypeColor(_type,_team,_big):
	var str_big = ""
	if _big > 0: str_big = "_big"
	var type_and_team = _type + "_" + _team + str_big
	match type_and_team:
		"spawn_blue": return Color(.6,.6,1)
		"spawn_red": return Color(1,.6,.6)
		"structure_blue","structure_red","structure_neutral": return Color(.8,1,.6)
		"structure_blue_big","structure_red_big": return Color(.6,.8,.4)
		"event_blue","event_red": return Color(.6,1,.8)
		"heart_blue": return Color(0,0,1)
		"heart_red": return Color(1,0,0)
		"stadium_neutral": return Color(.8,.8,.6)
		"stadium_area_neutral": return Color(1,1,.8)
		"normal_neutral": return Color(.9,.9,.9)
		_: return Color(0,0,0)

func get_color_by_element(element):
	var element_color
	match element:
		"neutral": element_color = Color(1,1,1)
		"ghost": element_color = Color(.6,.4,1)
		"fire": element_color = Color(1,.4,.2)
		"water": element_color = Color(.5,.7,1)
		"earth": element_color = Color(.7,.6,.3)
		"wind": element_color = Color(0,1,.5)
		"electric": element_color = Color(.4,1,.8)
		"devil": element_color = Color(.8,.4,.5)
		"holy": element_color = Color(.9,.9,.6)
		"shadow": element_color = Color(0,.3,.6)
		"light": element_color = Color(1,1,0)
		"poison": element_color = Color(.7,0,.8)
	return element_color

func get_custom_color(what):
	var custom_color
	match what:
		"blue": custom_color = Color(0,0,1)
		"red": custom_color = Color(1,0,0)
		"physical": custom_color = Color(1,.7,.7)
		"magical": custom_color = Color(.7,.7,1)
	return custom_color

func get_contrast_color(color,x_=.5):
	var new_color
	if color.r + color.g + color.b < 1.51:
		new_color = color.lightened(x_)
	else:
		new_color = color.darkened(x_)
	return new_color