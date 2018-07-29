extends PanelContainer

onready var ddbb = get_node("/root/ddbb")

onready var full_name = $main_box/Name
onready var image = $main_box/Image
onready var current_hp = $main_box/HP_box/HP_bar_box/HP_values/hp_current
onready var max_hp = $main_box/HP_box/HP_bar_box/HP_values/hp_max
onready var hp_bar_bg = $main_box/HP_box/HP_bar_box/HP_bar_bg
onready var hp_bar_progress = $main_box/HP_box/HP_bar_box/HP_bar_progress
onready var current_sp = $main_box/SP_box/SP_bar_box/SP_values/sp_current
onready var max_sp = $main_box/SP_box/SP_bar_box/SP_values/sp_max
onready var sp_bar_bg = $main_box/SP_box/SP_bar_box/SP_bar_bg
onready var sp_bar_progress = $main_box/SP_box/SP_bar_box/SP_bar_progress
onready var atk = $main_box/Stats_box/values1/atk_value
onready var aspd = $main_box/Stats_box/values1/aspd_value
onready var def = $main_box/Stats_box/values1/def_value
onready var mdef = $main_box/Stats_box/values1/mdef_value
onready var atk_type = $main_box/Stats_box/values1/atk_type_value
onready var element = $main_box/Stats_box/values1/element_value
onready var vel = $main_box/Stats_box/values2/vel_value
onready var agi = $main_box/Stats_box/values2/agi_value
onready var rng = $main_box/Stats_box/values2/range_value
onready var fly = $main_box/Stats_box/values2/fly_value

var current_hp_var = 100
var max_hp_var = 100
var hp_bar_width = 0
var current_sp_var = 100
var max_sp_var = 100
var sp_bar_width = 0
var tw

func _ready():
	##-- test:
	#show_by_id(2,{damage_count=850,soul_count=1150})
	#----------#
	tw = Tween.new()
	tw.connect("tween_step",self,"on_tween_stepped")
	tw.connect("tween_completed",self,"on_tween_completed")
	add_child(tw)
	call_deferred("update_hp_sp")

func update_hp_sp():
	update_hp()
	update_sp()
	
func show_by_id(card_id,tile):
	var card = ddbb.getByID(card_id)
	full_name.text = card.names[1]
	image.texture = load("res://assets/collections/"+card.collection+"-icos/"+card.names[0]+".png")
	current_hp.text = str(card.hp_sp.hp - tile.damage_count)
	current_hp_var = card.hp_sp.hp - tile.damage_count
	max_hp.text = str(card.hp_sp.hp)
	max_hp_var = card.hp_sp.hp
	current_sp.text = str(card.hp_sp.sp - tile.soul_count)
	current_sp_var = card.hp_sp.sp - tile.soul_count
	max_sp.text = str(card.hp_sp.sp)
	max_sp_var = card.hp_sp.sp
	atk.text = str(card.atks.atk)
	aspd.text = str(card.atks.aspd)
	def.text = str(card.defs.def)
	mdef.text = str(card.defs.mdef)
	atk_type.text = card.atks.atk_type
	element.text = card.atks.element
	vel.text = str(card.defs.vel)
	agi.text = str(card.defs.agi)
	rng.text = str(card.atks.reach)
	fly.text = "yes" if card.defs.fly == true else "no"
	######-- FANCY --######
	#-- atk_type:
	atk_type.set("custom_colors/font_color",ddbb.get_custom_color(card.atks.atk_type))
	atk_type.text = " " + atk_type.text + " "
	var style_box_1 = StyleBoxFlat.new()
	style_box_1.bg_color = ddbb.get_contrast_color(atk_type.get("custom_colors/font_color"))
	atk_type.set("custom_styles/normal",style_box_1)
	#-- element:
	element.set("custom_colors/font_color", ddbb.get_color_by_element(card.atks.element))
	element.text = " " + element.text + " "
	var style_box_2 = StyleBoxFlat.new()
	style_box_2.bg_color = ddbb.get_contrast_color(element.get("custom_colors/font_color"))
	element.set("custom_styles/normal",style_box_2)
	update_hp_sp()

func update_hp():
	hp_bar_width = hp_bar_bg.rect_size.x
	var final_width = current_hp_var * hp_bar_width / max_hp_var
	hp_bar_progress.rect_min_size.x = final_width
	hp_bar_progress.rect_size.x = final_width
	var hp_percent = current_hp_var / float(max_hp_var)
	if hp_percent > 0.5:
		hp_bar_progress.self_modulate = Color(1.5-hp_percent,2-hp_percent,0)
	else:
		hp_bar_progress.self_modulate = Color(1,hp_percent*2,0)
	current_hp.text = str(int(current_hp_var))

func update_sp():
	sp_bar_width = sp_bar_bg.rect_size.x
	var final_width = current_sp_var * sp_bar_width / max_sp_var
	sp_bar_progress.rect_min_size.x = final_width
	sp_bar_progress.rect_size.x = final_width
	var sp_percent = current_sp_var / float(max_sp_var)
	sp_bar_progress.self_modulate = Color(1-sp_percent,sp_percent*0.7,1)
	current_sp.text = str(int(current_sp_var))
	
func tween_x_to(what,value):
	self.set("is_"+what+"_tweening",true)
	var current_var = self.get("current_"+what+"_var")
	var max_var = self.get("max_"+what+"_var")
	var max_time = 4
	var time = max_time/float(abs(max_var/float(current_var-value)))
	tw.interpolate_property(self,"current_"+what+"_var",current_var,value,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tw.start()

func on_tween_stepped(object,key,elapsed,value):
	tween_hp_sp_update(key)

func on_tween_completed(object,key):
	tween_hp_sp_update(key)

func tween_hp_sp_update(key):
	if key == ":current_hp_var": update_hp()
	if key == ":current_sp_var": update_sp()