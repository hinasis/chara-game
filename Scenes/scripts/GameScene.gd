extends Control

onready var deskBG = $HBOX/VBOX/MainDeskC/DeskBG
onready var mainDeskGC = $HBOX/VBOX/MainDeskC/GC
onready var gradeGC1 = $HBOX/VBOX/HBOX/GradeGC1
onready var gradeGC2 = $HBOX/VBOX/HBOX/GradeGC2
onready var scenarioGC = $HBOX/VBOX/HBOX/ScenarioGC
onready var handBG = $HBOX/VBOX/HandC/HandBG
onready var handGC = $HBOX/VBOX/HandC/HBOX/HandGC
onready var hand_play_card_button = $HBOX/VBOX/HandC/HBOX/PlayCardButton
onready var hand_cancel_button = $HBOX/VBOX/HandC/HBOX/CancelButton
onready var hand_end_turn_button = $HBOX/VBOX/HandC/HBOX/EndTurnButton
onready var dd_bb = get_node("/root/ddbb")
onready var deck1 = load("res://ddbb/campain_deck_ddbb.gd").new().deck1_a
onready var deck2 = load("res://ddbb/campain_deck_ddbb.gd").new().deck2_a
onready var deck_test= load("res://ddbb/campain_deck_ddbb.gd").new().deck_test_a

var handTileSelected = -1
var is_waiting_action = false
var waiting_action = {"Action":"","Type":"","Card_ID":-1,"From":"","Has_subtype":false,"Subtype":""}
var handCardCount = 0
var player1Deck
var player2Deck
var whosTurn = "blue"
var yourTeam = "blue"
var colorBlue = Color(.2,.2,1,.8)
var colorRed = Color(1,.2,.2,.8)
var colorTransparent = Color(1,1,1,.01)
var deskTileSelected = -1
var blue_last_turn_hand = []
var red_last_turn_hand = []
var turnCount = 0
var blueTurnCount = 0
var redTurnCount = 0
var ev_simulate_leftclick

func _ready():
	# mouse left click event to simulate
	ev_simulate_leftclick = InputEventMouseButton.new()
	ev_simulate_leftclick.button_index = 1
	ev_simulate_leftclick.pressed = true
	# create desk and hand
	initDesk()
	initHand()
	# select deck and shuffle
	player1Deck = shuffleDeck(deck1)
	player2Deck = shuffleDeck(deck2)
	# draw 7 cards
	for i in range(0,7):
		drawCard()
	#whosTurn = "red"
	#yourTeam = "red"
	blueTurnCount = 1
	#redTurnCount = 1
	plog("Game Scene Ready!","green")
	plog("welcome")
	plog("_______","grey")

func initDesk():
	plog("loading desk")
	deskBG.texture = load("res://assets/desk/bg.jpg")

	var col = 0
	var row = 0
	for t in mainDeskGC.get_children():
		## border img:
		var border = TextureRect.new()
		border.texture = load("res://assets/desk/white_60_x_60.png")
		border.expand = true
		border.stretch_mode = TextureRect.STRETCH_TILE
		border.rect_min_size = Vector2(60,60)
		border.modulate = Color(1,1,1,.01)
		t.add_child(border)
		t.set_meta("bg",border)
		## image:
		var img = TextureRect.new()
		img.texture = load("res://assets/desk/empty-tile.jpg")
		img.expand = true
		img.stretch_mode = TextureRect.STRETCH_TILE
		img.rect_min_size = Vector2(50,50)
		t.add_child(img)
		t.set_meta("img",img)
		## connections:
		t.connect("gui_input",self,"tileClickHandler",[t])
		## meta:
		t.set_meta("occuped",false)
		t.set_meta("card owner","")
		t.set_meta("card",-1)
		t.set_meta("from","main desk")
		if col >= 0 and col < 5 : t.set_meta("team","blue")
		if col >= 5 and col < 7 : t.set_meta("team","neutral")
		if col >= 7 : t. set_meta("team","red")
		if col == 0 or (col == 1 and (row < 2 or row > 4) or (col == 2 and (row == 0 or row == 6))): t.set_meta("type","spawn")
		if col == 11 or (col == 10 and (row < 2 or row > 4) or (col == 9 and (row == 0 or row == 6))): t.set_meta("type","spawn")
		if (col == 0 or col == 11) and row == 3: t.set_meta("type","heart")
		if (col == 1 or col == 10) and row > 1 and row < 5: t.set_meta("type","area_small")
		if (col == 2 or col == 9) and row > 0 and row < 6: t.set_meta("type","area_small")
		if col > 2 and col < 9 and (row < 2 or row > 4): t.set_meta("type","area_medium")
		if col > 2 and col < 9 and (row > 1 and row < 5): t.set_meta("type","area_big")
		if col > 4 and col < 7 and row > 1 and row < 5: t.set_meta("type","stadio")
		t.set_meta("row",row)
		t.set_meta("col",col)
		## next tile:
		if col == 11: row += 1
		col += 1
		if col > 11:col = 0
	## grades and scenario:
	for n in $HBOX/VBOX/HBOX.get_children():
		for g in n.get_children():
			## border img:
			var border = TextureRect.new()
			border.texture = load("res://assets/desk/white_60_x_60.png")
			border.expand = true
			border.stretch_mode = TextureRect.STRETCH_TILE
			border.rect_min_size = Vector2(60,60)
			border.modulate = Color(1,1,1,.01)
			g.add_child(border)
			g.set_meta("bg",border)
			## image
			var img = TextureRect.new()
			img.texture = load("res://assets/desk/empty-tile.jpg")
			img.expand = true
			img.stretch_mode = TextureRect.STRETCH_TILE
			img.rect_min_size = Vector2(50,50)
			if g.get_index() == 1 and n.get_index() == 1:
				img.rect_min_size = Vector2(100,100)
				border.rect_min_size = Vector2(110,110)
			g.add_child(img)
			g.set_meta("img",img)
			## connections:
			g.connect("gui_input",self,"tileClickHandler",[g])
			## meta:
			g.set_meta("occuped",false)
			g.set_meta("card owner","")
			g.set_meta("card",-1)
			g.set_meta("from","scenario and grades")
			if n.get_index() == 0:
				g.set_meta("team","blue")
				g.set_meta("type","supporter_chair")
			if n.get_index() == 1:
				match g.get_index():
					0:
						g.set_meta("team","blue")
						g.set_meta("type","support_band")
					1:
						g.set_meta("team","neutral")
						g.set_meta("type","scenario")
					2:
						g.set_meta("team","red")
						g.set_meta("type","support_band")
			if n.get_index() == 2:
				g.set_meta("team","red")
				g.set_meta("type","supporter_chair")
func initHand():
	plog("loading hand")
	handBG.texture = load("res://assets/desk/bg.jpg")
	var handslot = 0
	for t in handGC.get_children():
		## border img:
		var border = TextureRect.new()
		border.texture = load("res://assets/desk/white_60_x_60.png")
		border.expand = true
		border.stretch_mode = TextureRect.STRETCH_TILE
		border.rect_min_size = Vector2(60,60)
		border.modulate = Color(1,1,1,.01)
		t.add_child(border)
		t.set_meta("bg",border)
		## img:
		var img = TextureRect.new()
		img.texture = load("res://assets/desk/empty-tile.jpg")
		img.expand = true
		img.stretch_mode = TextureRect.STRETCH_TILE
		img.rect_min_size = Vector2(50,50)
		t.add_child(img)
		t.set_meta("img",img)
		## connections:
		t.connect("gui_input",self,"tileClickHandler",[t])
		## meta:
		t.set_meta("from","hand")
		t.set_meta("slot",handslot)
		t.set_meta("card",-1)
		## next slot:
		handslot += 1
	hand_play_card_button.connect("gui_input",self,"playCard")
	hand_end_turn_button.connect("gui_input",self,"endTurn")
	hand_cancel_button.connect("gui_input",self,"cancelAction")


func tileClickHandler(ev,t):
	# in this function "t" is the event's tile, and "tile" is just a loop variable
	# "t+something" is a variable from "t"
	# waiting_action is a dictionary with "Action","Type","Card_ID","From","Has_subtype","Subtype"
	# it represents the played card that is waiting for being placed, for example
	if ev is InputEventMouseButton and ev.is_action_pressed("mouse_left"):
		if is_waiting_action:
			match waiting_action.Action:
				"card place":
					var tfrom = t.get_meta("from")
					# if tile is not your turn
					if yourTeam != whosTurn:
						plog("it's not your turn","yellow")
						return
					# if tile is not the area waiting for action
					if tfrom != waiting_action.From:
						plog("not here, try another area","yellow")
						return
					var ttype = t.get_meta("type")
					var tteam = t.get_meta("team")
					# if tile is not the type of tile expected
					if ttype != waiting_action.Type and !(waiting_action.Has_subtype and ttype == waiting_action.Subtype):
						if !((ttype == "support_band" or ttype == "scenario") and waiting_action.Type == "band"):
							if waiting_action.Has_subtype:
								if ttype != waiting_action.Subtype:
									plog(String(ttype)+" isn't "+String(waiting_action.Subtype),"yellow")
							elif ttype != waiting_action.Type: plog(String(ttype)+" isn't what expected","yellow")
							return
					# if tile is occuped
					if t.get_meta("occuped"):
						plog("tile occuped","yellow")
						return
					if tteam != yourTeam and tteam != "neutral":
						plog("it's the opponent's side","yellow")
						return
					waiting_action.Action = ""
					is_waiting_action = false
					match tfrom:
						"main desk":
							for tile in mainDeskGC.get_children():
								if tile.get_meta("type") == waiting_action.Type and tile.get_meta("occuped") == false:
									tile.get_meta("bg").modulate = colorTransparent
								if waiting_action.Type == "structure":
									tile.get_meta("bg").modulate = colorTransparent
						"scenario and grades":
							for tile in gradeGC1.get_children():
								if tile.get_meta("type") == waiting_action.Type and tile.get_meta("occuped") == false:
									tile.get_meta("bg").modulate = colorTransparent
							for tile in gradeGC2.get_children():
								if tile.get_meta("type") == waiting_action.Type and tile.get_meta("occuped") == false:
									tile.get_meta("bg").modulate = colorTransparent
							for tile in scenarioGC.get_children():
								if waiting_action.Type == "band" and tile.get_meta("occuped") == false:
									tile.get_meta("bg").modulate = colorTransparent
					var file = File.new()
					var card = dd_bb.getByID(waiting_action.Card_ID)
					var path = "res://assets/"+card.collection+"-icos/"+card.name+".png"
					if file.file_exists(path):
						t.get_meta("img").texture = load(path)
					else:
						t.get_meta("img").modulate = Color(.2,1,.2,.8)
					t.set_meta("card",waiting_action.Card_ID)
					match ttype:
						"stadio":
							for tile in mainDeskGC.get_children():
								var row = tile.get_meta("row")
								var col = tile.get_meta("col")
								if row > 1 and row < 5 and col > 4 and col < 7:
									if file.file_exists(path):
										tile.get_meta("img").texture = load(path)
									else:
										tile.get_meta("img").modulate = Color(.2,1,.2,.8)
									tile.set_meta("card",waiting_action.Card_ID)
									tile.set_meta("occuped",true)
									tile.set_meta("card owner",yourTeam)
						"area_medium":
							for tile in mainDeskGC.get_children():
								var row = tile.get_meta("row")
								var col = tile.get_meta("col")
								var tileteam = tile.get_meta("team")
								var trow = t.get_meta("row")
								var tcol = t.get_meta("col")
								## if in central area
								if (row < 2 or row > 4) and col > 2 and col < 9:
									# if in neutral area
									if col > 4 and col < 7 and tteam == "neutral":
										# if in top area
										if trow < 2 and row < 2:
											if file.file_exists(path):
												tile.get_meta("img").texture = load(path)
											else:
												tile.get_meta("img").modulate = Color(.2,1,.2,.8)
											tile.set_meta("card",waiting_action.Card_ID)
											tile.set_meta("occuped",true)
											tile.set_meta("card owner",yourTeam)
										# if in bottom area
										if trow > 4 and row > 4:
											if file.file_exists(path):
												tile.get_meta("img").texture = load(path)
											else:
												tile.get_meta("img").modulate = Color(.2,1,.2,.8)
											tile.set_meta("card",waiting_action.Card_ID)
											tile.set_meta("occuped",true)
											tile.set_meta("card owner",yourTeam)
									# if in blue central area
									if col > 2 and col < 5 and tteam == "blue" and yourTeam == "blue":
										#if in top area
										if trow < 2 and row < 2:
											if file.file_exists(path):
												tile.get_meta("img").texture = load(path)
											else:
												tile.get_meta("img").modulate = Color(.2,1,.2,.8)
											tile.set_meta("card",waiting_action.Card_ID)
											tile.set_meta("occuped",true)
											tile.set_meta("card owner",yourTeam)
										# if in bottom area
										if trow > 4 and row > 4:
											if file.file_exists(path):
												tile.get_meta("img").texture = load(path)
											else:
												tile.get_meta("img").modulate = Color(.2,1,.2,.8)
											tile.set_meta("card",waiting_action.Card_ID)
											tile.set_meta("occuped",true)
											tile.set_meta("card owner",yourTeam)
									# if in red central area
									if col > 6 and col < 9 and tteam == "red" and yourTeam == "red":
										# if in top area
										if trow < 2 and row < 2:
											if file.file_exists(path):
												tile.get_meta("img").texture = load(path)
											else:
												tile.get_meta("img").modulate = Color(.2,1,.2,.8)
											tile.set_meta("card",waiting_action.Card_ID)
											tile.set_meta("occuped",true)
											tile.set_meta("card owner",yourTeam)
										# if in bottom area
										if trow > 4 and row > 4:
											if file.file_exists(path):
												tile.get_meta("img").texture = load(path)
											else:
												tile.get_meta("img").modulate = Color(.2,1,.2,.8)
											tile.set_meta("card",waiting_action.Card_ID)
											tile.set_meta("occuped",true)
											tile.set_meta("card owner",yourTeam)
						"area_big":
							for tile in mainDeskGC.get_children():
								var row = tile.get_meta("row")
								var col = tile.get_meta("col")
								if row > 1 and row < 5 and col > 2 and col < 5 and tile.get_meta("team") == yourTeam:
									if file.file_exists(path):
										tile.get_meta("img").texture = load(path)
									else:
										tile.get_meta("img").modulate = Color(.2,1,.2,.8)
									tile.set_meta("card",waiting_action.Card_ID)
									tile.set_meta("occuped",true)
									tile.set_meta("card owner",yourTeam)
								if row > 1 and row < 5 and col > 6 and col < 9 and tile.get_meta("team") == yourTeam:
									if file.file_exists(path):
										tile.get_meta("img").texture = load(path)
									else:
										tile.get_meta("img").modulate = Color(.2,1,.2,.8)
									tile.set_meta("card",waiting_action.Card_ID)
									tile.set_meta("occuped",true)
									tile.set_meta("card owner",yourTeam)
					waiting_action.Type = ""
					plog("card nº: "+String(waiting_action.Card_ID)+" played!","green")
					waiting_action.Card_ID = -1
					t.set_meta("occuped",true)
					t.set_meta("card owner",yourTeam)
					freeAndUpdateHand()
					deselectHandCard()
					handCardCount -= 1
					waiting_action.Has_subtype = false
					waiting_action.Subtype = ""
				"chara move":
					if t.get_meta("from") != waiting_action.From:
						plog("not here, try another area","yellow")
						return
					if t.get_meta("occuped"):
						if t == mainDeskGC.get_child(deskTileSelected):
							cancelAction(ev_simulate_leftclick)
							return
						plog("it's occuped","yellow")						
						return
					var row = t.get_meta("row")
					var col = t.get_meta("col")
					var stile = mainDeskGC.get_child(deskTileSelected)
					var orow = stile.get_meta("row")
					var ocol = stile.get_meta("col")
					var card = dd_bb.getByID(waiting_action.Card_ID)
					var should_move = false
					var d = 3
					for i in range(4):
						if (orow -i == row or orow +i == row) and abs(col - ocol) <= d:
							should_move = true
						d -= 1
					if should_move:
						t.get_meta("img").texture = load("res://assets/"+card.collection+"-icos/"+card.name+".png")
						stile.get_meta("img").texture = load("res://assets/desk/empty-tile.jpg")
						t.set_meta("occuped",true)
						stile.set_meta("occuped",false)
						t.set_meta("card owner",stile.get_meta("card owner"))
						stile.set_meta("card onwer","")
						t.set_meta("card",card.id)
						stile.set_meta("card",-1)
						waiting_action.Action = ""
						waiting_action.From = ""
						waiting_action.Card_ID = -1
						is_waiting_action = false
						for mtile in mainDeskGC.get_children():
							mtile.get_meta("bg").modulate = colorTransparent
						deskTileSelected = -1
					else: plog("it's out of range","yellow")
		elif !is_waiting_action:
			var card_id = t.get_meta("card")
			showCardInfo(card_id)
			match t.get_meta("from"):
				"main desk":
					var tn = t.get_index()
					var row = t.get_meta("row")
					var col = t.get_meta("col")
					var team = t.get_meta("team")
					var type = t.get_meta("type")
					var card_owner = t.get_meta("card owner")
					var owner_color = "white"
					if card_owner == "blue": owner_color = "#7777ff"
					if card_owner == "red": owner_color = "#ff7777"
					plog("desk row "+String(row)+" col "+String(col)+"[color="+owner_color+"]"+", card "+String(card_id)+"[/color]")
					plog("team "+team+", type "+type)
					plog("__________","grey")
					if card_id != -1:
						match card_owner:
							"blue": t.get_meta("bg").modulate = colorBlue
							"red": t.get_meta("bg").modulate = colorRed
						if deskTileSelected != -1:
							mainDeskGC.get_child(deskTileSelected).get_meta("bg").modulate = colorTransparent
						var prev_tile_selected = deskTileSelected
						deskTileSelected = tn
						if whosTurn == yourTeam and card_owner == yourTeam:
							if dd_bb.getByID(card_id).type == "chara" and deskTileSelected == prev_tile_selected:
								for mtile in mainDeskGC.get_children():
									var mtrow = mtile.get_meta("row")
									var mtcol = mtile.get_meta("col")
									if abs(mtrow - row) + abs(mtcol - col) <= 3:
										if mtile != t:
											mtile.get_meta("bg").modulate = Color(.6,.6,0,.5)
								is_waiting_action = true
								waiting_action.Action = "chara move"
								waiting_action.From = "main desk"
								waiting_action.Card_ID = card_id
	
				"scenario and grades":
					var tn = t.get_index()
					var team = t.get_meta("team")
					var type = t.get_meta("type")
					var card_owner = t.get_meta("card owner")
					var owner_color = "white"
					if card_owner == "blue": owner_color = "#7777ff"
					if card_owner == "red": owner_color = "#ff7777"
					plog("team: "+team+", type: "+type)
					plog("[color="+owner_color+"]"+"card nº: "+String(card_id)+"[/color]")
					plog("__________","grey")
				"hand":
					var tn = t.get_meta("slot")
					plog("hand slot "+String(tn)+", card "+String(card_id))
					plog("__________","grey")
					if handTileSelected != -1: ## deselect last before select the new
						handGC.get_child(handTileSelected).get_meta("bg").modulate = colorTransparent
					if handTileSelected != t.get_meta("slot"):
						handTileSelected = t.get_meta("slot")
						if yourTeam == "blue":
							t.get_meta("bg").modulate = colorBlue
						if yourTeam == "red":
							t.get_meta("bg").modulate = colorRed
					elif handTileSelected == t.get_meta("slot"):
						deselectHandCard()

func playCard(ev):
	if !(ev is InputEventMouseButton): return
	if handTileSelected != -1 and ev.is_action_pressed("mouse_left"):
		if yourTeam != whosTurn:
			plog("it isn't your turn","yellow")
			return
		if handGC.get_child(handTileSelected).get_meta("card") == -1:
			plog("this slot empty","yellow")
			return
		var card_id = handGC.get_child(handTileSelected).get_meta("card")
		waiting_action.Card_ID = card_id
		var cardtype = dd_bb.getByID(card_id).type
		var target_border_color
		if yourTeam == "blue":
			target_border_color = colorBlue
		if yourTeam == "red":
			target_border_color = colorRed
		var found = false
		match cardtype:
			"chara":
				plog("chara")
				for t in mainDeskGC.get_children():
					if t.get_meta("type") == "spawn" and !t.get_meta("occuped") and t.get_meta("team") == whosTurn:
						t.get_meta("bg").modulate = target_border_color
						if found == false: found = true
				if found == true:
					waiting_action.Type = "spawn"
					waiting_action.From = "main desk"
			"support":
				if whosTurn == "blue":
					for t in gradeGC1.get_children():
						if !t.get_meta("occuped"):
							t.get_meta("bg").modulate = target_border_color
							if found == false: found = true
				if whosTurn == "red":
					for t in gradeGC2.get_children():
						if !t.get_meta("occuped"):
							t.get_meta("bg").modulate = target_border_color
							if found == false: found = true
				if found == true:
					waiting_action.Type = "supporter_chair"
					waiting_action.From = "scenario and grades"
			"stadio":
				for t in mainDeskGC.get_children():
					var row = t.get_meta("row")
					var col = t.get_meta("col")
					if row > 1 and row < 5 and col > 4 and col < 7 and !t.get_meta("occuped"):
						t.get_meta("bg").modulate = target_border_color
						if found == false: found = true
				if found == true:
					waiting_action.Type = "stadio"
					waiting_action.From = "main desk"
			"structure":
				var subtype = ""
				for t in mainDeskGC.get_children():
					var tiletype = t.get_meta("type")
					var cardsize = dd_bb.getByID(card_id).size
					if cardsize == "small":
						if (tiletype == "area_small") and t.get_meta("team") == whosTurn and !t.get_meta("occuped"):
							t.get_meta("bg").modulate = target_border_color
							if found == false:
								found = true
								subtype = tiletype
					elif cardsize == "medium":
						if tiletype == "area_medium" and (t.get_meta("team") == whosTurn or t.get_meta("team") == "neutral") and !t.get_meta("occuped"):
							t.get_meta("bg").modulate = target_border_color
							if found == false:
								found = true
								subtype = tiletype
					elif cardsize == "big":
						if tiletype == "area_big" and t.get_meta("team") == whosTurn and !t.get_meta("occuped"):
							t.get_meta("bg").modulate = target_border_color
							if found == false:
								found = true
								subtype = tiletype
				if found == true:
					waiting_action.Type = "structure"
					waiting_action.Has_subtype = true
					waiting_action.Subtype = subtype
					waiting_action.From = "main desk"
					plog(subtype)
			"band":
				for t in scenarioGC.get_children():
					if !t.get_meta("occuped") and (t.get_meta("team") == whosTurn or t.get_meta("team") == "neutral"):
						t.get_meta("bg").modulate = target_border_color
						if found == false: found = true
				if found == true:
					waiting_action.Type = "band"
					waiting_action.From = "scenario and grades"
		if found == true:
			is_waiting_action = true
			waiting_action.Action = "card place"
		else:
			plog("there is no place to play it","yellow")

func endTurn(ev):
	if !(ev is InputEventMouseButton) or !(ev.is_action_pressed("mouse_left")): return
	plog("turn ended","aqua")
	if whosTurn == "blue":
		### test block ###
		blue_last_turn_hand = []
		for c in handGC.get_children():
			blue_last_turn_hand.append([c.get_meta("img").texture,c.get_meta("card")])
		blue_last_turn_hand.append(handCardCount)
		##################
		blueTurnCount += 1
		whosTurn = "red"
	else:
		### test block ###
		red_last_turn_hand = []
		for c in handGC.get_children():
			red_last_turn_hand.append([c.get_meta("img").texture,c.get_meta("card")])
		red_last_turn_hand.append(handCardCount)
		##################
		redTurnCount += 1
		whosTurn = "blue"
	# temp to test:
	if yourTeam == "blue":
		if redTurnCount != 0:
			handCardCount = red_last_turn_hand[10]
			for i in range(10):
				handGC.get_child(i).get_meta("img").texture = red_last_turn_hand[i][0]
				handGC.get_child(i).set_meta("card",red_last_turn_hand[i][1])
		else:
			handCardCount = 0
			for i in range(10):
				for t in handGC.get_children():
					t.get_meta("img").texture = load("res://assets/desk/empty-tile.jpg")
					t.set_meta("card",-1)
			for i in range(7):
				drawCard()
		yourTeam = "red"
	else:
		if blueTurnCount != 0:
			handCardCount = blue_last_turn_hand[10]
			for i in range(10):
				handGC.get_child(i).get_meta("img").texture = blue_last_turn_hand[i][0]
				handGC.get_child(i).set_meta("card",blue_last_turn_hand[i][1])
		else:
			handCardCount = 0
			for i in range(10):
				for t in handGC.get_children():
					t.get_meta("img").texture = load("res://assets/desk/empty-tile.jpg")
					t.set_meta("card",-1)
			for i in range(7):
				drawCard()
		yourTeam = "blue"
	drawCard()

func cancelAction(ev):
	if !(ev is InputEventMouseButton) or !(ev.is_action_pressed("mouse_left")):return
	if !is_waiting_action:
		plog("no action to cancel")
		return
	plog("\""+waiting_action.Action+"\" action canceled")
	is_waiting_action = false
	waiting_action.Action = ""
	waiting_action.Type = ""
	waiting_action.Subtype = ""
	waiting_action.Has_subtype = ""
	waiting_action.Card_ID = ""
	match waiting_action.From:
		"main desk":
			for t in mainDeskGC.get_children():
				t.get_meta("bg").modulate = colorTransparent
				deskTileSelected = -1
		"scenario and grades":
			for g in $HBOX/VBOX/HBOX.get_children():
				for t in g.get_children():
					t.get_meta("bg").modulate = colorTransparent
	waiting_action.From = ""

func drawCard():
	var playingDeck
	if whosTurn == "blue": playingDeck = player1Deck.duplicate()
	if whosTurn == "red": playingDeck = player2Deck.duplicate()
	if playingDeck.size() > 0:
		if handCardCount < 10:
			var card = dd_bb.getByID(playingDeck[0])
			handGC.get_child(handCardCount).set_meta("card",playingDeck[0])
			playingDeck.pop_front()
			var f = File.new()
			var path = "res://assets/"+card.collection+"-icos/"+card.name+".png"
			if f.file_exists(path):
				handGC.get_child(handCardCount).get_meta("img").texture = load(path)
			else:
				var temp_color
				match card.type:
					"chara": temp_color = Color(.2,1,.2,.85)
					"support": temp_color = Color(0,.6,.6,.85)
					"stadio": temp_color = Color(.6,.2,.6,.85)
					"structure": temp_color = Color(.5,.5,.7,.85)
					"band": temp_color = Color(.7,.5,0,.85)
				handGC.get_child(handCardCount).get_meta("img").modulate = temp_color
			handCardCount += 1
			if whosTurn == "blue": player1Deck = playingDeck.duplicate()
			if whosTurn == "red": player2Deck = playingDeck.duplicate()

func freeAndUpdateHand():
	# "removes" the played card and move the next cards to the left
	var i = handTileSelected
	var textures = []
	var modulates = []
	var cards = []
	if i < 10: # 10 is the number of slots, so 0 to 9
		# saves cards to the right of played one
		for n in range(i+1,10): # from the next to the played to the last one
			textures.append(handGC.get_child(n).get_meta("img").texture)
			modulates.append(handGC.get_child(n).get_meta("img").modulate)
			cards.append(handGC.get_child(n).get_meta("card"))
		# then place one by one over the played to the right
		var q = 0 # because the next range doesn't starts at 0
		for n in range(i,9): # 9 because you get from the selected one to near last
			handGC.get_child(n).get_meta("img").texture = textures[q]
			handGC.get_child(n).get_meta("img").modulate = modulates[q]
			handGC.get_child(n).set_meta("card",cards[q])
			q += 1
		# finally empty the last slot
		handGC.get_child(9).get_meta("img").texture = load("res://assets/desk/empty-tile.jpg")
		handGC.get_child(9).get_meta("img").modulate = Color(1,1,1)
		handGC.get_child(9).set_meta("card",-1)

func deselectHandCard():
	handGC.get_child(handTileSelected).get_meta("bg").modulate = Color(1,1,1,.01)
	handTileSelected = -1

func shuffleDeck(deck):
	var shuffledDeck = []
	var indexDeck = range(deck.size())
	for i in range(deck.size()):
		randomize()
		var x = randi()%indexDeck.size()
		shuffledDeck.append(deck[x])
		indexDeck.remove(x)
		deck.remove(x)
	return shuffledDeck

func plog(txt,color="white",underline=false,bold=false,italic=false):
	var myString = "[color="+color+"]"+String(txt)+"[/color]"
	if underline: myString = "[u]"+myString+"[/u]"
	if bold: myString = "[b]"+myString+"[/b]"
	if italic: myString = "[i]"+myString+"[/b]"
	$HBOX/PANELC/VBOX/LOG.append_bbcode(myString+"\n")

func showCardInfo(id):
	if id == -1: return
	var card = dd_bb.getByID(id)
	var _id = String(card.id)
	var _name = String(card.name).to_upper()
	var img_path = "res://assets/"+card.collection+"-icos/"+card.name+".png"
	var bbtext = "[right][u]"+_name+"[/u]\ncard nº: "+_id+"[/right]"
	if card.type == "chara":
		var _hp = String(card.hp)
		var _atk = String(card.atk)
		var _def = String(card.def)
		var _spd = String(card.spd)
		var _rng = String(card.rng)
		bbtext = bbtext + "[u]\nCharacter stats:[/u]"
		bbtext = bbtext + "[table=4][cell]\t\t[/cell][cell]\t[/cell][cell]\t\t[/cell][cell]\t[/cell]"
		bbtext = bbtext + "[cell][u]HP:[/u][/cell][cell]"+_hp+"[/cell][cell][/cell][cell][/cell]"
		bbtext = bbtext + "[cell][u]ATK:[/u][/cell][cell]"+_atk+"[/cell]"
		bbtext = bbtext + "[cell][u]DEF:[/u][/cell][cell]"+_def+"[/cell]"
		bbtext = bbtext + "[cell][u]SPD:[/u][/cell][cell]"+_spd+"[/cell]"
		bbtext = bbtext + "[cell][u]RNG:[/u][/cell][cell]"+_rng+"[/cell][/table]"
	if card.type == "structure":
		var _size = String(card.size)
		var _hp = String(card.hp)
		bbtext = bbtext + "[table=2][cell]\t\t[/cell][cell]\t\t[/cell]"
		bbtext = bbtext + "[cell][u]SIZE:[/u][/cell][cell]"+_size.to_upper()+"[/cell]"
		bbtext = bbtext + "[cell][u]HP:[/u][/cell][cell]"+_hp+"[/cell][/table]"
	bbtext = bbtext+"[right][img]"+img_path+"[/img][/right]"
	$HBOX/PANELC/VBOX/PANELC/CARDINFO.bbcode_text = bbtext







