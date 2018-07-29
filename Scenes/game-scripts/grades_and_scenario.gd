extends HBoxContainer

signal tile_clicked
signal card_actioned
signal notify

onready var Tile_Class = load("res://Scenes/game-scripts/tile.gd")

var team_1_grades = HBoxContainer.new()
var team_2_grades = HBoxContainer.new()
var scenarios = HBoxContainer.new()
var grades_1_tiles = []
var grades_2_tiles = []
var blue_band
var red_band
var main_scenario

var waiting_for_action = false
var expected_action = {type="",card_id=-1,card_type=""}
var highlighted_tiles = []
var last_tile_clicked = null

func _init():
	size_flags_horizontal = SIZE_SHRINK_CENTER
	set("custom_constants/separation",217) #62 (tile width) times 3.5 (remanent)

func _ready():
	create_grade("blue")
	create_scenario()
	create_grade("red")

func on_tile_click_handler(tile):
	if waiting_for_action:
		if not tile in highlighted_tiles:
			return
		var action_to_emit = ""
		var is_action_done = false
		match expected_action.type:
			"place":
				match expected_action.card_type:
					"support":
						tile.call("place_support",expected_action.card_id,GameGlobals.your_team)
						action_to_emit = "placed"
						is_action_done = true
					"band":
						tile.call("place_band",expected_action.card_id,GameGlobals.your_team)
						action_to_emit = "placed"
						is_action_done = true
		if action_to_emit != "": emit_signal("card_actioned",action_to_emit)
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
	emit_signal("notify","play request received")
	var answer = false
	var action_type = ""
	var array_to_check = []
	match card_type:
		"support":
			if GameGlobals.your_team == "blue":
				array_to_check = grades_1_tiles
			else: array_to_check = grades_2_tiles
			action_type = "place"
		"band":
			if GameGlobals.your_team == "blue":
				array_to_check = [blue_band, main_scenario]
			else: array_to_check = [red_band, main_scenario]
			action_type = "place"
	for tile in array_to_check:
		match card_type:
			"support":
				if not tile.occuped:
					if answer == false:
						answer = true
					tile.turn_highlight()
					highlighted_tiles.append(tile)
			"band":
				if not tile.occuped:
					if answer == false:
						answer = true
					tile.turn_highlight()
					highlighted_tiles.append(tile)
	if answer == true:
		waiting_for_action = true
		expect_action(action_type,card_id,card_type)
	return answer

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
	
### deck creation:
func create_grade(team):
	var grade
	match team:
		"blue": grade = team_1_grades
		"red": grade = team_2_grades
	grade.alignment = ALIGN_CENTER
	grade.set("custom_constants/separation",0)
	for i in range(4):
		var tile = Tile_Class.new()
		tile.tile_id = i
		tile.team = team
		tile.type = "grade"
		tile.from = "grades"
		grade.add_child(tile)
		tile.connect("tile_clicked",self,"on_tile_click_handler",[tile])
		
		match team:
			"blue": grades_1_tiles.append(tile)
			"red": grades_2_tiles.append(tile)
	add_child(grade)
	notify("grades created")
	
func notify(msg):
	emit_signal("notify",msg)
	
func create_scenario():
	blue_band = Tile_Class.new()
	red_band = Tile_Class.new()
	main_scenario = Tile_Class.new()
	blue_band.tile_id = 0
	red_band.tile_id = 2
	main_scenario.tile_id = 1
	blue_band.team = "blue"
	red_band.team = "red"
	main_scenario.team = "neutral"
	blue_band.type = "support_band"
	red_band.type = "support_band"
	main_scenario.type = "main_scenario"
	blue_band.from = "scenarios"
	red_band.from = "scenarios"
	main_scenario.from = "scenarios"
	scenarios.add_child(blue_band)
	scenarios.add_child(main_scenario)
	scenarios.add_child(red_band)
	scenarios.set("custom_constants/separation",0)
	add_child(scenarios)
	blue_band.connect("tile_clicked",self,"on_tile_click_handler",[blue_band])
	red_band.connect("tile_clicked",self,"on_tile_click_handler",[red_band])
	main_scenario.connect("tile_clicked",self,"on_tile_click_handler",[main_scenario])
	notify("scenario created")