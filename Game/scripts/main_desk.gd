extends GridContainer

signal dragged_card
signal dropped_card
signal attacked
signal card_placed

var blue_tile_groups = {
	spawn = [],
	event = [],
	structure_small = [],
	structure_big = [[],[]],
	structures = [],
	heart = null
}
var red_tile_groups = {
	spawn = [],
	event = [],
	structure_small = [],
	structure_big = [[],[]],
	structures = [],
	heart = null
}
var neutral_tile_groups = {
	normal = [],
	structure_small = [],
	structure_big = [[],[]],
	structures = [],
	stadium = [],
	stadium_area = []
}
var grid_map = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]] #-- basen on [col][row]

var group_highlighted_to_attack = []
var group_highlighted_to_move = []

func _ready():
	set_tile_info()
	
	#-- testing:
	test_func()

func test_func():
	#-- blues
	var b_card_ids = [0,1,2,3]
	var b_tile_idx = [23,39,111,131]
	for i in range(b_tile_idx.size()):
		get_child(b_tile_idx[i]).place_card(b_card_ids[i],"blue","chara")
	#-- reds
	var r_card_ids = [0,1,2,3]
	var r_tile_idx = [30,50,122,138]
	for i in range(r_tile_idx.size()):
		get_child(r_tile_idx[i]).place_card(r_card_ids[i],"red","chara")

func on_desk_changed(change):
	match change.type:
		"card_placed":
			match change.target_tile.tile_status.card_type:
				"chara":
					report_surroundings("placed",change.target_tile)
		"card_removed":
			report_surroundings("removed",change.target_tile)

func report_surroundings(what,tile):
	var answer = 1 if what == "placed" else 0
	var counter_side = [7,6,5,4,3,2,1,0]
	for i in range(tile.tile_info.surroundings.size()):
		if tile.tile_info.surroundings[i] != -1:
			get_child(tile.tile_info.surroundings[i]).tile_info.sr_occupeds[counter_side[i]] = answer

func can_drop_data_fw(position, data, tile):
	if tile == data.drag_tile: return false
	var card_id = data.card_id
	var card_type = ddbb.getByID(card_id).type
	var tile_type = tile.tile_info.type
	var tile_team = tile.tile_info.team
	var your_team = GameGlobals.your_team
	match data.from:
		"hand":
			match card_type:
				"chara":
					if tile_type == "spawn" and tile_team == your_team and not tile.tile_status.occuped:
						return true
				"support":
					if tile_type == "support" and tile_team == your_team: return true
				"stadio":
					if tile_type == "stadium" and is_ally_near_tile(tile): return true
				"structure":
					if tile_type == "structure" and is_ally_near_tile(tile) and (tile_team == your_team or tile_team == "neutral"):
						var card_size = ddbb.getByID(card_id).size
						var tile_size = tile.tile_info.is_big
						if card_size == "small" and tile_size == 0: return true
						if card_size == "big" and tile_size > 0:
							var your_big_group
							match your_team:
								"blue": your_big_group = blue_tile_groups.structure_big
								"red":  your_big_group = red_tile_groups.structure_big
							for big_group in your_big_group:
								if tile in big_group:
									var is_group_occuped = 0
									for big_tile in big_group:
										if big_tile.tile_status.occuped:
											is_group_occuped += 1
									if is_group_occuped == 0:
										return true
				"band":
					if tile_type == "band" and tile_team == your_team: return true
				"event":
					if tile_type == "event" and tile_team == your_team: return true
				"terrain":
					if not tile_type in ["spawn","support","band","event","stadio"]:
						if is_ally_near_tile(tile): return true
		"desk":
			match card_type:
				"chara":
					if tile in (group_highlighted_to_attack + group_highlighted_to_move): return true
	return false


func drop_data_fw(position, data, tile):
	if tile == data.drag_tile: return
	var from = data.from
	var card_id = data.card_id
	var type_of_card = ddbb.getByID(card_id).type
	var your_team = GameGlobals.your_team
	match from:
		"hand":
			match type_of_card:
				"chara","support","stadio","band":
					if not tile.place_card(card_id,your_team,type_of_card): return
					if type_of_card == "chara":
						on_desk_changed({type="card_placed",target_tile=tile})
				"structure":
					match ddbb.getByID(card_id).size:
						"small":
							if not tile.place_card(card_id,your_team,type_of_card): return
						"big":
							var your_big_group
							match your_team:
								"blue": your_big_group = blue_tile_groups.structure_big
								"red": your_big_group = red_tile_groups.structure_big
							for big_group in your_big_group:
								if tile in big_group:
									for big_tile in big_group:
										if not big_tile.place_card(card_id,your_team,type_of_card): return
				"terrain":
					if not tile.place_terrain(card_id,your_team): return
				"event":
					if not tile.place_event(card_id,your_team,0): return
			emit_signal("card_placed",tile)
		"desk":
			var drag_tile = data.drag_tile
			match type_of_card:
				"chara":
					if tile.tile_status.occuped:
						emit_signal("attacked",drag_tile,tile)
					else:
						if not tile.place_card(card_id,your_team,type_of_card): return
						drag_tile.remove("chara")
						on_desk_changed({type="card_placed",target_tile=tile})
						on_desk_changed({type="card_removed",target_tile=drag_tile})

func get_drag_data_fw(position, tile):
	if not GameGlobals.is_your_turn(): return
	if tile.tile_status.card_owner != GameGlobals.your_team: return
	match tile.tile_status.card_type:
		"chara":
			#-- preview:
			var particle_preview = load("res://assets/game_ui/particles/animated/particle_01.tscn").instance()
			var preview = Container.new()
			preview.add_child(particle_preview)
			set_drag_preview(preview)
			preview.connect("tree_exited",self,"on_dropped_data")
			#-- extras:
			if not tile.tile_props.has_attacked:
				highlight_targets_in_range_to(tile,"attack")
			if not tile.tile_props.has_moved:
				highlight_targets_in_range_to(tile,"move")
			#-- end
			emit_signal("dragged_card")
			return {from="desk",card_id=tile.tile_status.card_placed,drag_tile=tile}

func on_dropped_data():
	for target in group_highlighted_to_attack:
		target.get_node("Highlight Attack").visible = false
	for target in group_highlighted_to_move:
		target.get_node("Highlight Move").visible = false
	group_highlighted_to_attack = []
	group_highlighted_to_move = []
	emit_signal("dropped_card")

func is_in_range(drag_tile,target_tile,for_what):
	match for_what:
		"attack":
			if target_tile in group_highlighted_to_attack: return true
		"move":
			if target_tile in group_highlighted_to_move: return true
	return false

func is_ally_near_tile(tile):
	for neighbour_id in tile.tile_info.surroundings:
		if neighbour_id != -1:
			var neighbour = get_child(neighbour_id)
			if neighbour.tile_status.occuped and neighbour.tile_status.card_type == "chara":
				if neighbour.tile_status.card_owner == GameGlobals.your_team:
					return true
	return false

func highlight_targets_in_range_to(tile,to_what):
	var targets = get_targets_in_range(tile,to_what)
	for target in targets:
		if target.tile_status.occuped and target.tile_status.card_owner != GameGlobals.your_team:
			target.get_node("Highlight Attack").visible = true
			group_highlighted_to_attack.append(target)
		elif not target.tile_status.occuped:
			target.get_node("Highlight Move").visible = true
			group_highlighted_to_move.append(target)

func get_targets_in_range(tile,for_what):
	var max_dis
	var card_id = tile.tile_status.card_placed
	match for_what:
		"attack": max_dis = ddbb.getByID(card_id).atks.reach
		"move": max_dis = ddbb.getByID(card_id).defs.vel
	var row = tile.tile_info.row
	var col = tile.tile_info.column
	var targets_in_range = []
	for target_col_idx in range(col-max_dis,col+max_dis+1):
		var dis = abs(target_col_idx-col)
		for target_row_idx in range(row-max_dis+dis,row+max_dis-dis+1):
			if target_col_idx in range(18) and target_row_idx in range(9):
				if !(target_col_idx == col and target_row_idx == row):
					targets_in_range.append(grid_map[target_col_idx][target_row_idx])
	return targets_in_range

func highlight_target_group_for(what):
	var target_group
	match what:
		"chara":
			match GameGlobals.your_team:
				"blue": target_group = blue_tile_groups.spawn
				"red": target_group = red_tile_groups.spawn
		"structure":
			match GameGlobals.your_team:
				"blue": target_group = blue_tile_groups.structure_small
				"red": target_group = red_tile_groups.structure_small
		"structure_big":
			match GameGlobals.your_team:
				"blue": target_group = blue_tile_groups.structure_big[0]+blue_tile_groups.structure_big[1]
				"red": target_group = red_tile_groups.structure_big[0]+red_tile_groups.structure_big[1]
	for tile in target_group:
		tile.turn_highlight()

func set_tile_info():
	
	var type_matrix = [
		1,1,1,1,0,0,4,4,4,4,4,4,0,0,1,1,1,1,
		1,1,1,0,0,0,4,4,4,4,4,4,0,0,0,1,1,1,
		1,1,0,0,5,5,7,7,7,7,7,7,5,5,0,0,1,1,
		2,1,4,0,5,5,7,7,7,7,7,7,5,5,0,4,1,2,
		2,3,4,0,0,0,7,7,6,6,7,7,0,0,0,4,3,2,
		2,1,4,0,5,5,7,7,7,7,7,7,5,5,0,4,1,2,
		1,1,0,0,5,5,7,7,7,7,7,7,5,5,0,0,1,1,
		1,1,1,0,0,0,4,4,4,4,4,4,0,0,0,1,1,1,
		1,1,1,1,0,0,4,4,4,4,4,4,0,0,1,1,1,1
	]
	
	var team_matrix = [
		0,0,0,0,2,2,0,0,2,2,1,1,2,2,1,1,1,1,
		0,0,0,2,2,2,0,0,2,2,1,1,2,2,2,1,1,1,
		0,0,2,2,0,0,2,2,2,2,2,2,1,1,2,2,1,1,
		0,0,0,2,0,0,2,2,2,2,2,2,1,1,2,1,1,1,
		0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,
		0,0,0,2,0,0,2,2,2,2,2,2,1,1,2,1,1,1,
		0,0,2,2,0,0,2,2,2,2,2,2,1,1,2,2,1,1,
		0,0,0,2,2,2,0,0,2,2,1,1,2,2,2,1,1,1,
		0,0,0,0,2,2,0,0,2,2,1,1,2,2,1,1,1,1
	]
	var row_count = 0
	var col_count = 0
	for i in range(get_children().size()):
		var tile = get_child(i)
		#-- from:
		tile.tile_info.from = "desk"
		#-- tile_id:
		tile.tile_info.tile_id = i
		#-- column and row:
		tile.tile_info.column = col_count
		tile.tile_info.row = row_count
		#-- neighbour:
		var n
		n = i-19 #topleft
		if col_count > 0 and row_count > 0: tile.tile_info.surroundings[0] = n
		n = n+1 #top
		if row_count > 0: tile.tile_info.surroundings[1] = n
		n = n+1 #topright
		if col_count < 17 and row_count > 0: tile.tile_info.surroundings[2] = n
		n = i-1 #left
		if col_count > 0: tile.tile_info.surroundings[3] = n
		n = i+1 #right
		if col_count < 17: tile.tile_info.surroundings[4] = n
		n = i+17 #bottomleft
		if col_count > 0 and row_count < 8: tile.tile_info.surroundings[5] = n
		n = n+1
		if row_count < 8: tile.tile_info.surroundings[6] = n
		n = n+1
		if col_count < 17 and row_count < 8: tile.tile_info.surroundings[7] = n
		#-- register to grid_map:
		grid_map[col_count].append(tile)
		#-- next column and row:
		col_count += 1
		if col_count == 18:
			col_count = 0
			row_count += 1
		#-- team:
		match team_matrix[i]:
			0: tile.tile_info.team = "blue"
			1: tile.tile_info.team = "red"
			2: tile.tile_info.team = "neutral"
		#-- type:
		match type_matrix[i]:
			0:
				tile.tile_info.type = "normal"
				neutral_tile_groups.normal.append(tile)
			1:
				tile.tile_info.type = "spawn"
				match tile.tile_info.team:
					"blue": blue_tile_groups.spawn.append(tile)
					"red": red_tile_groups.spawn.append(tile)
			2:
				tile.tile_info.type = "event"
				match tile.tile_info.team:
					"blue": blue_tile_groups.event.append(tile)
					"red": red_tile_groups.event.append(tile)
			3:
				tile.tile_info.type = "heart"
				match tile.tile_info.team:
					"blue": blue_tile_groups.heart = tile
					"red": red_tile_groups.heart = tile
			4:
				tile.tile_info.type = "structure"
				match tile.tile_info.team:
					"blue": blue_tile_groups.structure_small.append(tile)
					"blue": blue_tile_groups.structures.append(tile)
					"red": red_tile_groups.structure_small.append(tile)
					"red": red_tile_groups.structures.append(tile)
					"neutral": neutral_tile_groups.structure_small.append(tile)
					"neutral": neutral_tile_groups.structures.append(tile)
			5:
				tile.tile_info.type = "structure"
				match tile.tile_info.team:
					"blue": blue_tile_groups.structures.append(tile)
					"red": red_tile_groups.structures.append(tile)
				#-- is_big:
				match tile.tile_info.tile_id:
					40,94,48,102: tile.tile_info.is_big = 1
					41,95,49,103: tile.tile_info.is_big = 2
					58,112,66,120: tile.tile_info.is_big = 3
					59,113,67,121: tile.tile_info.is_big = 4
				match tile.tile_info.tile_id:
					40,41,58,59: blue_tile_groups.structure_big[0].append(tile)
					94,95,112,113: blue_tile_groups.structure_big[1].append(tile)
					48,49,66,67: red_tile_groups.structure_big[0].append(tile)
					102,103,120,121: red_tile_groups.structure_big[1].append(tile)
					
			6:
				tile.tile_info.type = "stadium"
				neutral_tile_groups.stadium.append(tile)
			7:
				tile.tile_info.type = "stadium_area"
				neutral_tile_groups.stadium_area.append(tile)
		#-- bg:
		var new_bg_color = ddbb.getDeskTileTypeColor(tile.tile_info.type,tile.tile_info.team,tile.tile_info.is_big)
		tile.get_node("Background").self_modulate = new_bg_color
		#-- forward drag and drop:
		tile.set_drag_forwarding(self)