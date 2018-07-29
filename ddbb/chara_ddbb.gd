extends Node

var ca = []
func _init():
	var CHARA
	
####################################
	##### collection: to love ru:
	
	#-- LALA:
	CHARA = {
		names = ["Lala","Lala Satalin Deviluke"],
		source = "To Love-ru",
		hp_sp = {hp= 1500, sp= 1000},
		atks = {atk= 500, aspd= 1, atk_type= "magical", element= "neutral", reach= 1},
		defs = {def= 200, mdef= 300, vel= 2, agi= 3, fly= true},
		skill_1 = {name= "fly-spin", type= "attack", atk_type= "physical", damage= 300, cost= 150, has_effects=true, count= 1},
		skill_1_effect_1 = {type= "extra_range",extra_range= 1},
		skill_2 = {name= "deviluke's punch", type= "damage", atk_type= "physical", damage= 500, cost= 200, has_effects=false},
		skill_count = 2,
		collection = "to-love-ru",
		cost = {hate=0,love=0,kawaii=0,gore=0}
	}
	ca.append(CHARA.duplicate())
	#-- YAMI
	CHARA = {
		names = ["Yami","Yami, Golden Darkness"],
		source = "To Love-ru",
		hp_sp = {hp= 1000, sp= 800},
		atks = {atk= 75, aspd= 2, atk_type= "physical", element= "neutral", reach= 2},
		defs = {def= 300, mdef= 200, vel= 3, agi= 4, fly= false},
		skill_1 = {name= "hair blade slash", type= "attack", atk_type= "physical", damage= 300, cost= 100, has_effects=false},
		skill_2 = {name= "hair ball", type= "self_buff", cost= 300, count=2},
		skill_2_effect_1 = {type= "buff_stat", stat= "def", amount= 100},
		skill_2_effect_2 = {type= "buff_stat", stat= "mdef", amount= 100},
		skill_count = 2,
		collection = "to-love-ru",
		cost = {hate=0,love=0,kawaii=0,gore=0}
	}
	ca.append(CHARA.duplicate())
	#-- MEA
	CHARA = {
		names = ["Mea","Mea Kurosaki"],
		source = "To Love-ru",
		hp_sp = {hp= 900, sp= 1200},
		atks = {atk= 75, aspd= 1, atk_type= "physical", element= "neutral", reach= 2},
		defs = {def= 200, mdef= 100, vel= 3, agi= 2, fly= false},
		skill_1 = {name= "hair blade slash", type= "attack", atk_type= "physical", damage= 300, cost= 100, has_effects=false},
		skill_2 = {name= "psycho dive", type= "attack", atk_type= "magical", damage= 400, cost= 400, has_effects=true, count= 2},
		skill_2_effect_1 = {type= "debuff", stat= "mdef", amount= 100},
		skill_2_effect_2 = {type= "debuff", stat= "vel", amount= 1},
		skill_count = 2,
		collection = "to-love-ru",
		cost = {hate=0,love=0,kawaii=0,gore=0}
	}
	ca.append(CHARA.duplicate())
	#-- NANA
	CHARA = {
		names = ["Nana","Nana Astar Deviluke"],
		source = "To Love-ru",
		hp_sp = {hp= 750, sp= 900},
		atks = {atk= 50, aspd= 2, atk_type= "physical", element= "neutral", reach= 1},
		defs = {def= 100, mdef= 400, vel= 2, agi= 2, fly= true},
		skill_1 = {name= "devilukean tail", type= "attack", atk_type= "magical", damage= 150, cost= 100, has_effects=false},
		skill_2 = {name= "d-dial: gii-chan", type= "summon", cost= 600},
		skill_2_effect_1 = { pet_id = 1},
		skill_3 = {name= "d-dial: cloud-on", type= "summon", cost= 600},
		skill_3_effect_1 = {pet_id = 2},
		skill_count = 3,
		collection = "to-love-ru",
		cost = {hate=0,love=0,kawaii=0,gore=0}
	}
	ca.append(CHARA.duplicate())
	#-- NEME
	CHARA = {
		names = ["Nemesis","Master Nemesis"],
		source = "To Love-ru",
		hp_sp = {hp= 1100, sp= 1000},
		atks = {atk= 75, aspd= 1, atk_type= "physical", element= "neutral", reach= 2},
		defs = {def= 500, mdef= 200, vel= 2, agi= 2, fly= false},
		skill_1 = {name= "hair blade slash", type= "attack", atk_type= "physical", damage= 300, cost= 100, has_effects=false},
		skill_2 = {name= "shadow form", type= "self_buff", cost= 400, has_effects= true, count= 2},
		skill_2_effect_1 = {type= "alter_status", stat= "targetable", value= false},
		skill_2_effect_2 = {type= "self_heal", amount= 200},
		skill_3 = {name= "body jack", type= "debuff", cost= 1000, count= 3},
		skill_3_effect_1 = {type= "self_damage", amount= 1000 },
		skill_3_effect_2 = {type= "possess"},
		skill_count = 3,
		collection = "to-love-ru",
		cost = {hate=0,love=0,kawaii=0,gore=0}
	}
	ca.append(CHARA.duplicate())
	
	
	
#	var CHARA = {name="",stats={},collection=""}
#	#----------------------------------------------------#
#	CHARA.name = "alpha"
#	CHARA.stats = {hp= 100, atk= 5, def= 5, spd= 1, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "beta"
#	CHARA.stats = {hp= 95, atk= 10, def= 10, spd= 1, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "gamma"
#	CHARA.stats = {hp= 90, atk= 15, def= 15, spd= 2, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "delta"
#	CHARA.stats = {hp= 85, atk= 20, def= 20, spd= 2, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "epsilon"
#	CHARA.stats = {hp= 80, atk= 25, def= 25, spd= 3, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "zeta"
#	CHARA.stats = {hp= 75, atk= 30, def= 30, spd= 3, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "eta"
#	CHARA.stats = {hp= 70, atk= 35, def= 35, spd= 4, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "theta"
#	CHARA.stats = {hp= 65, atk= 40, def= 40, spd= 4, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "iota"
#	CHARA.stats = {hp= 60, atk= 45, def= 45, spd= 5, rng= 3}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "kappa"
#	CHARA.stats = {hp= 55, atk= 50, def= 50, spd= 5, rng= 3}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "lambda"
#	CHARA.stats = {hp= 50, atk= 55, def= 55, spd= 6, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "mu"
#	CHARA.stats = {hp= 45, atk= 60, def= 60, spd= 6, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "nu"
#	CHARA.stats = {hp= 40, atk= 65, def= 65, spd= 7, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "xi"
#	CHARA.stats = {hp= 45, atk= 45, def= 75, spd= 6, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "omicron"
#	CHARA.stats = {hp= 50, atk= 40, def= 65, spd= 6, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "pi"
#	CHARA.stats = {hp= 55, atk= 35, def= 65, spd= 5, rng= 3}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "rho"
#	CHARA.stats = {hp= 60, atk= 30, def= 60, spd= 5, rng= 3}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "sigma"
#	CHARA.stats = {hp= 65, atk= 25, def= 55, spd= 4, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "tau"
#	CHARA.stats = {hp= 70, atk= 20, def= 50, spd= 4, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "upsilon"
#	CHARA.stats = {hp= 75, atk= 15, def= 45, spd= 3, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "phi"
#	CHARA.stats = {hp= 80, atk= 10, def= 40, spd= 3, rng= 2}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "chi"
#	CHARA.stats = {hp= 85, atk= 5, def= 35, spd= 2, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "psi"
#	CHARA.stats = {hp= 90, atk= 0, def= 30, spd= 2, rng= 1}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
#	#----------------------------------------------------#
#	CHARA.name = "omega"
#	CHARA.stats = {hp= 95, atk= 0, def= 25, spd= 1, rng= 3}
#	CHARA.collection = "greek-charas"
#	ca.append(CHARA.duplicate())
	
	