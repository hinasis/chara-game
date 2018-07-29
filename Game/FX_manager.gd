extends Node

var audio_player

var damage_indicator = load("res://Game/fxs/fx nodes/damage_indicator.tscn")

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

func fx_card_placed(on_tile):
	play_sound("res://assets/sound fx/desk/place_1.wav","1/8")
	var particles = load("res://assets/game_ui/particles/animated/particle_02.tscn").instance()
	particles.global_position = on_tile.get_global_position()+on_tile.get_size()*0.5
	add_child(particles)
	particles.restart()
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = particles.lifetime
	timer.connect("timeout",self,"remove_children",[[particles,timer]])
	add_child(timer)

func fx_attack(atk_tile,def_tile,damage,step=0):
	match step:
		0:
			pass
		1:
			#-- flash red
			var tw = Tween.new()
			var tw_time = 0.5
			tw_flash_color(tw,def_tile.portrait,Color(1,0,0),0.5)
			add_child(tw)
			#-- damage indicator
			var di = damage_indicator.instance()
			var dt_gr_pos = def_tile.get_global_position()
			di.damage = damage
			di.rect_position = Vector2(dt_gr_pos.x, dt_gr_pos.y)
			add_child(di)
			#-- step duration:
			var step_duration = 0
			step_duration = tw_time
			if step_duration < di.duration: step_duration = di.duration
			#-- next step:
			var timer = Timer.new()
			timer.one_shot = true
			add_child(timer)
			timer.connect("timeout",self,"fx_attack",[atk_tile,def_tile,damage,step+1])
			timer.connect("timeout",self,"remove_children",[[tw,di,timer]])
			timer.wait_time = step_duration
			timer.start()
			#-- play animation:
			tw.start()
			di.play()

#--- utils:
func play_sound(path,bus="Master"):
	audio_player.stream = load(path)
	audio_player.bus = bus
	audio_player.play()

func tw_disappear(tw,target,time):
	tw.interpolate_property(target,"modulate",target.modulate,Color(1,1,1,0),time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	
func tw_flash_color(tw,target,color,time):
	tw.interpolate_property(target,"modulate",target.modulate,color,time*0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	tw.interpolate_property(target,"modulate",color,target.modulate,time*0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,time*0.5)

func remove_children(children):
	for child in children:
		remove_child(child)