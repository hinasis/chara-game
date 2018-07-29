extends GridContainer

signal tile_clicked
signal card_actioned
signal notify
signal fx

onready var Tile_Control = load("res://Scenes/game-scripts/tile.gd")

var rows_array = [[]]
var cols_array = [[]]
var heart_1t = null
var heart_2t = null
var team_1_array = {spawns=[],events=[],smalls=[],bigs=[[],[]]}
var team_2_array = {spawns=[],events=[],smalls=[],bigs=[[],[]]}
var neutral_smalls_array = []
var stadio_array = []
var arena_array = []

var last_tile_clicked = null
var waiting_for_action = false
var expected_action = {type="",card_id="",card_type=""}
var highlighted_tiles = []
var last_damage_done = 0
var last_atk_id = 0
var last_def_id = 0

func _init():
	columns = 18
	set("custom_constants/vseparation",0)
	set("custom_constants/hseparation",0)

func _ready():
	createDesk()

func tile_click_handler(tile):
	if waiting_for_action:
		if  not (tile in highlighted_tiles):
			notify("it's not a targeted tile")
			return
		var action_to_emit = ""
		var is_action_done = false
		match expected_action.type:
			"place":
				match expected_action.card_type:
					"chara":
						tile.call("place_chara",expected_action.card_id,GameGlobals.your_team)
						action_to_emit = "placed"
						is_action_done = true
					"structure":
						var _insides = ddbb.getByID(expected_action.card_id).insides
						var _id = expected_action.card_id
						if ddbb.getByID(expected_action.card_id).size == "big":
							for big in team_1_array.bigs:
								if tile in big:
									for target in big:
										target.call("place_structure",_id,_insides,"blue")
							for big in team_2_array.bigs:
								if tile in big:
									for target in big:
										target.call("place_structure",_id,_insides,"red")
						else:
							tile.call("place_structure",_id,_insides,GameGlobals.your_team)
						action_to_emit = "placed"
						is_action_done = true
					"stadio":
						for target in stadio_array:
							target.call("place_stadio",expected_action.card_id)
						action_to_emit = "placed"
						is_action_done = true
			"move":
				if tile == last_tile_clicked:
					action_to_emit = "cancelled"
				else:
					tile.call("place_chara",expected_action.card_id,GameGlobals.your_team)
					action_to_emit = "moved"
				is_action_done = true
			"attack":
				if tile == last_tile_clicked:
					action_to_emit = "cancelled"
				else:
					var attacker = ddbb.getByID(last_tile_clicked.card_placed)
					var defender = ddbb.getByID(tile.card_placed)
					## for fxs, save current state:
					last_atk_id = attacker.id
					last_def_id = defender.id
					GameGlobals.chara_panel_ref.show_by_id(last_def_id,tile)
					##---------------------------##
					last_damage_done = GameGlobals.calculate_damage(attacker,defender)
					if tile.call("damage",last_damage_done):
						
						action_to_emit = "attacked"
					else:
						print("can't be damaged")
						action_to_emit = "cancelled"
				is_action_done = true
		if action_to_emit != "":
			##--------- FX calls -------##
			match action_to_emit:
				"placed":
					fx_request("place",null,tile)
				"moved":
					fx_request("move",null,tile)
				"attacked":
					fx_request("attack",[last_damage_done,last_atk_id,last_def_id],tile)
				"cancelled":
					pass
			##--------------------------##
			emit_signal("card_actioned",action_to_emit)
		if is_action_done: cancel_action()
		return
	elif last_tile_clicked != null:
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
	emit_signal("tile_clicked",tile)

func play_request(card_type,card_id):
	notify("play request received")
	var answer = false
	var action_type = ""
	var array_to_check = []
	match card_type:
		"chara":
			if GameGlobals.your_team == "blue":
				array_to_check = team_1_array.spawns
			else: array_to_check = team_2_array.spawns
			action_type = "place"
		"structure":
			var structure_size = ddbb.getByID(card_id).size
			if structure_size == "small":
				if GameGlobals.your_team == "blue":
					array_to_check = team_1_array.smalls + neutral_smalls_array
				else: array_to_check = team_2_array.smalls + neutral_smalls_array
			if structure_size == "big":
				if GameGlobals.your_team == "blue":
					array_to_check = team_1_array.bigs[0] + team_1_array.bigs[1]
				else: array_to_check = team_2_array.bigs[0] + team_2_array.bigs[1]
			action_type = "place"
		"stadio":
			array_to_check = stadio_array
			action_type = "place"
	var mixed_answer = []
	var highlight_queue = []
	for tile in array_to_check:
		match card_type:
			"chara":
				if !tile.occuped:
					if answer == false:
						answer = true
					highlight_queue.append(tile)
			"structure":
				if is_your_chara_near(tile):
					if tile.is_big != -1:
						if !tile.occuped:
							mixed_answer.append(0)
							highlight_queue.append(tile)
						else:
							mixed_answer.append(1)
					else:
						if !tile.occuped:
							if answer == false:
								answer = true
							highlight_queue.append(tile)
			"stadio":
				if is_your_chara_near(tile):
					if !tile.occuped:
						mixed_answer.append(0)
						highlight_queue.append(tile)
					else:
						mixed_answer.append(1)
	if mixed_answer.size() != 0:
		var _resolution = 0
		for _answer in mixed_answer:
			_resolution += _answer
		if _resolution == 0:
			answer = true
	if answer:
		for target in highlight_queue:
			target.turn_highlight()
			highlighted_tiles.append(target)
		waiting_for_action = true
		expect_action(action_type,card_id,card_type)
	return answer


func action_request(action,tile):
	notify(action+" request received")
	var targeted_tiles
	match action:
		"move": targeted_tiles = get_tiles_to_move(tile)
		"attack": targeted_tiles = get_tiles_to_attack(tile)
	for target in targeted_tiles:
		target.turn_highlight()
		highlighted_tiles.append(target)
	if targeted_tiles.size() > 0:
		waiting_for_action = true
		expect_action(action,tile.card_placed,tile.card_type)
		return true
	else:
		return false

func get_tiles_to_move(tile):
	var mov_spd = ddbb.getByID(tile.card_placed).defs.vel
	var target_tiles = []
	for i in range(tile.column-mov_spd,tile.column+mov_spd+1):
		for target in cols_array[i]:
			if !target.occuped or target == tile:
				var distance = abs(target.row-tile.row) + abs(target.column-tile.column)
				if distance <= mov_spd:
					target_tiles.append(target)
	if target_tiles.size() == 1 and target_tiles[0] == tile:
		target_tiles = []
	return target_tiles
	
func get_tiles_to_attack(tile):
	var the_range = ddbb.getByID(tile.card_placed).atks.reach
	var target_tiles = []
	for i in range(tile.column-the_range,tile.column+the_range+1):
		for target in cols_array[i]:
			if target.occuped or target == tile:
				var distance = abs(target.row-tile.row) + abs(target.column-tile.column)
				if distance <= the_range:
					target_tiles.append(target)
	if target_tiles.size() == 1 and target_tiles[0] == tile:
		target_tiles = []
	return target_tiles

func is_your_chara_near(tile):
	for i in range(tile.column-1,tile.column+2):
		for target in cols_array[i]:
			var rows = [tile.row-1,tile.row,tile.row+1]
			if target.row in rows:
				if target.card_type == "chara" and target.card_owner == GameGlobals.your_team:
					return true
	return false

func expect_action(_type,_card_id,_card_type):
	expected_action.type = _type
	expected_action.card_id = _card_id
	expected_action.card_type = _card_type
func default_expected_action():
	expected_action.type = ""
	expected_action.card_id = -1
	expected_action.card_type = ""

func unhighlight_all():
	for tile in highlighted_tiles:
		tile.turn_highlight()
	highlighted_tiles = []

func cancel_action():
	unhighlight_all()
	waiting_for_action = false
	if last_tile_clicked != null:
		last_tile_clicked.turn_select()
	last_tile_clicked = null
	default_expected_action()

func fx_request(_fx,_vars,tile):
	emit_signal("fx",_fx,_vars,tile)

func notify(msg):
	emit_signal("notify",msg)

func createDesk():
	var row_count = 0
	var col_count = 0
	for i in range(162):
		var tile = Tile_Control.new()
		tile.tile_id = i
		tile.from = "desk"
		tile.column = col_count
		tile.row = row_count
		
		## setting types ##
		# t1 and t2 hearts:
		if i == 73: heart_1t = tile
		if i == 88: heart_2t = tile
		# t1 spawn:
		var t1s = range(0,4) + range(18,21) + [36,37,55] + [91,108,109] + range(126,129) + range(144,148)
		if i in t1s:
			tile.type = "spawn"
			tile.team = "blue"
			team_1_array.spawns.append(tile)
		# t2 spawn:
		var t2s = range(14,18) + range(33,36) + [52,53,70] + [106,124,125] + range(141,144) + range(158,162)
		if i in t2s:
			tile.type = "spawn"
			tile.team = "red"
			team_2_array.spawns.append(tile)
		# t1 and t2 events:
		if i in [54,72,90]:
			tile.type = "event"
			tile.team = "blue"
			team_1_array.events.append(tile)
		if i in [71,89,107]:
			tile.type = "event"
			tile.team = "red"
			team_2_array.events.append(tile)
		# t1 smalls:
		if i in [56,74,92,6,7,24,25,132,133,150,151]:
			tile.type = "small"
			tile.team = "blue"
			team_1_array.smalls.append(tile)
		# t2 smalls:
		if i in [69,87,105,10,11,28,29,136,137,154,155]:
			tile.type = "small"
			tile.team = "red"
			team_2_array.smalls.append(tile)
		# neutral smalls:
		if i in [8,9,26,27,134,135,152,153]:
			tile.type = "small"
			tile.team = "neutral"
			neutral_smalls_array.append(tile)
		# t1 bigs:
		var t1bigs = [40,41,58,59,94,95,112,113]
		if i in t1bigs:
			if i == t1bigs[0] or i == t1bigs[4]:
				tile.is_big = 0
			if i == t1bigs[1] or i == t1bigs[5]:
				tile.is_big = 1
			if i == t1bigs[2] or i == t1bigs[6]:
				tile.is_big = 2
			if i == t1bigs[3] or i == t1bigs[7]:
				tile.is_big = 3
			tile.type = "big"
			tile.team = "blue"
			for n in range(0,4):
				if i == t1bigs[n]:
					team_1_array.bigs[0].append(tile)
			for n in range(4,8):
				if i == t1bigs[n]:
					team_1_array.bigs[1].append(tile)
		# t2 bigs:
		var t2bigs = [48,49,66,67,102,103,120,121]
		if i in t2bigs:
			if i == t2bigs[0] or i == t2bigs[4]:
				tile.is_big = 0
			if i == t2bigs[1] or i == t2bigs[5]:
				tile.is_big = 1
			if i == t2bigs[2] or i == t2bigs[6]:
				tile.is_big = 2
			if i == t2bigs[3] or i == t2bigs[7]:
				tile.is_big = 3
			tile.type = "big"
			tile.team = "red"
			for n in range(0,4):
				if i == t2bigs[n]:
					team_2_array.bigs[0].append(tile)
			for n in range(4,8):
				if i == t2bigs[n]:
					team_2_array.bigs[1].append(tile)
		# stadio pair of tiles:
		if i == 80 or i == 81:
			tile.type = "stadio"
			tile.team = "neutral"
			stadio_array.append(tile)
		# arena tiles:
		if i in [42,47,60,65,78,79,82,83,96,101,114,119]:
			tile.type = "arena"
			tile.team = "neutral"
			arena_array.append(tile)
		###################
		tile.connect("tile_clicked",self,"tile_click_handler",[tile])
		add_child(tile)
		rows_array[row_count].append(tile)
		cols_array[col_count].append(tile)
		
			# for next i:
		if col_count == 17:
			col_count = 0
			row_count += 1
			rows_array.append([])
		else:
			col_count += 1
			cols_array.append([])
	emit_signal("notify","desk created")