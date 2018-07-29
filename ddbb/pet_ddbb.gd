extends Node

var pet_owners = {}

func _ready():
	pet_owners["Nana"] = {
		num_pets = 2,
		pet_1 = {
			names = ["Gii-chan","Gii-chan"],
			source = "Nana's cyber safari park",
			hp_sp = {hp= 500, sp= 1},
			atks = {atk= 50, aspd= 1, atk_type= "physical", element= "neutral", reach= 1},
			defs = {def= 200, mdef= 100, vel= 3, agi= 1, fly= false},
			skill_count = 0,
			collection = "to-love-ru-icos/pets",
			cost = {hate=0,love=0,kawaii=0,gore=0}
		},
		pet_2 = {
			names = ["Cloud-on","Cloud-on"],
			source = "Nana's cyber safari park",
			hp_sp = {hp= 300, sp= 1},
			atks = {atk= 100, aspd= 1, atk_type= "physical", element= "neutral", reach= 2},
			defs = {def= 100, mdef= 200, vel= 1, agi= 1, fly= true},
			skill_count = 0,
			collection = "to-love-ru-icos/pets",
			cost = {hate=0,love=0,kawaii=0,gore=0}
		}
	}
