extends Node

var tweener
var audio_player
var chara_panel_ref = null
var attack_ui = load("res://Scenes/game-subscenes/Attacking_UI.tscn").instance()

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

func fx_request(fx,vars,tile):
	match fx:
		"attack":
			pre_tile_attack(vars[0],tile,vars[1],vars[2])
		"move":
			tile_moved()
		"place":
			tile_placed(tile)

func pre_tile_attack(amount,tile,attacker,defender):
	add_child(attack_ui)
	if tile.tile_status.card_placed != -1:
		attack_ui.connect("shaded_off",self,"tile_attack",[amount,tile],CONNECT_ONESHOT)
	else:
		attack_ui.connect("shaded_off",self,"tile_dead",[tile],CONNECT_ONESHOT)
	attack_ui.connect("shaded_off",self,"remove_child",[attack_ui],CONNECT_ONESHOT)
	attack_ui.actionate(attacker,defender)
	##CHARA PANEL:
	if chara_panel_ref != null:
		var panel = GameGlobals.chara_panel_ref
		if panel.current_hp_var - amount > 0:
			panel.tween_x_to("hp",panel.current_hp_var-amount)
		else:
			panel.tween_x_to("hp",0)

func tile_attack(amount,tile):
	## SOUND (path,bus):
	play_sound("res://assets/sound fx/desk/hit_4.wav","1/16")
	## TWEENER:
	tweener = Tween.new()
	add_child(tweener)
	## DAMAGE LABEL:
	var num_label = Label.new()
	num_label.text = "-"+str(amount)
	num_label.set("custom_colors/font_color",Color(.8,0,0))
	var font = load("res://assets/fonts/calibri-24.tres")
	num_label.set("custom_fonts/font",font)
	tile.add_child(num_label)
	##### TWEENS #####
	var param
	var from
	var to
	var time = 0.75
	## TWEEN 1:
	param = "rect_scale"
	from = num_label.rect_scale
	to = Vector2(1.2,1.2)
	tweener.interpolate_property(num_label,param,from,to,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	## TWEEN 2:
	param = "rect_position"
	from = num_label.rect_position
	to = num_label.rect_position + Vector2(-12,-50)
	tweener.interpolate_property(num_label,param,from,to,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	## TWEEN 3:
	param = "self_modulate"
	from = num_label.self_modulate
	to = Color(num_label.self_modulate.r,num_label.self_modulate.g,num_label.self_modulate.b,0)
	tweener.interpolate_property(num_label,param,from,to,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	## TWEEN 4:
	param = "self_modulate"
	from = Color(.5,0,0)
	to = Color(1,1,1)
	tweener.interpolate_property(tile.get_node("Portrait"),param,from,to,time,Tween.TRANS_SINE,Tween.EASE_OUT)
	####: finally:
	tweener.connect("tween_completed",self,"free_after_tween",[num_label])
	tweener.start()

func tile_dead(tile):
	## SOUND (path,bus):
	play_sound("res://assets/sound fx/desk/dead_1.wav","1/8")
	var blood_splash = load("res://assets/game_ui/particles/Blood Splash.tscn").instance()
	blood_splash.position = tile.rect_size/2.0
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = blood_splash.lifetime
	tile.add_child(blood_splash)
	timer.connect("timeout",tile,"remove_child",[blood_splash],CONNECT_ONESHOT)
	timer.connect("timeout",self,"remove_child",[timer],CONNECT_ONESHOT)
	timer.start()

func tile_moved():
	play_sound("res://assets/sound fx/desk/move_3.wav","1/16")

func tile_placed(tile):
	play_sound("res://assets/sound fx/desk/place_1.wav","1/16")
	tweener = Tween.new()
	add_child(tweener)
	var param
	var from
	var to
	var time = 0.5
	## TWEEN 1:
	param = "self_modulate"
	from = Color(.5,1,0)
	to = tile.self_modulate
	tweener.interpolate_property(tile.border,param,from,to,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tweener.connect("tween_completed",self,"free_after_tween")
	tweener.start()

func free_after_tween(tween,tween_key,what=null):
	if what != null:
		what.queue_free()
	remove_child(tweener)
	
func play_sound(path,bus="Master"):
	audio_player.stream = load(path)
	audio_player.bus = bus
	audio_player.play()
	