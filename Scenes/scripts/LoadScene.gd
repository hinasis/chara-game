extends Control

onready var slot1 = $LoadMenu/VBOX/Slot1
onready var slot2 = $LoadMenu/VBOX/Slot2
onready var slot3 = $LoadMenu/VBOX/Slot3
onready var slot4 = $LoadMenu/VBOX/Slot4
onready var slot5 = $LoadMenu/VBOX/Slot5
onready var slot6 = $LoadMenu/VBOX/Slot6
onready var slot7 = $LoadMenu/VBOX/Slot7
onready var slot8 = $LoadMenu/VBOX/Slot8
onready var slot9 = $LoadMenu/VBOX/Slot9
onready var slot10 = $LoadMenu/VBOX/Slot10
onready var back_button = $LoadMenu/VBOX/BackButton

func nextScene(sceneName):
	if sceneName == "back":
		if get_node("/root/global").previousSceneName == "SaveLoad":
			sceneName = "SaveLoad"
		elif get_node("/root/global").previousSceneName == "Lobby":
			sceneName = "Lobby"
	get_node("/root/global").delayNextScene(sceneName)

func loadFromSlot(i):
	print("load from slot " + String(i))

func _ready():
	slot1.connect("button_down",self,"loadFromSlot",[1])
	slot2.connect("button_down",self,"loadFromSlot",[2])
	slot3.connect("button_down",self,"loadFromSlot",[3])
	slot4.connect("button_down",self,"loadFromSlot",[4])
	slot5.connect("button_down",self,"loadFromSlot",[5])
	slot6.connect("button_down",self,"loadFromSlot",[6])
	slot7.connect("button_down",self,"loadFromSlot",[7])
	slot8.connect("button_down",self,"loadFromSlot",[8])
	slot9.connect("button_down",self,"loadFromSlot",[9])
	slot10.connect("button_down",self,"loadFromSlot",[10])
	back_button.connect("button_down",self,"nextScene",["back"])
