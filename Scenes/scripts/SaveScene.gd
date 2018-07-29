extends Control

onready var slot1 = $SaveMenu/VBOX/Slot1
onready var slot2 = $SaveMenu/VBOX/Slot2
onready var slot3 = $SaveMenu/VBOX/Slot3
onready var slot4 = $SaveMenu/VBOX/Slot4
onready var slot5 = $SaveMenu/VBOX/Slot5
onready var slot6 = $SaveMenu/VBOX/Slot6
onready var slot7 = $SaveMenu/VBOX/Slot7
onready var slot8 = $SaveMenu/VBOX/Slot8
onready var slot9 = $SaveMenu/VBOX/Slot9
onready var slot10 = $SaveMenu/VBOX/Slot10
onready var back_button = $SaveMenu/VBOX/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func saveAtSlot(i):
	print("save at slot " + String(i))

func _ready():
	slot1.connect("button_down",self,"saveAtSlot",[1])
	slot2.connect("button_down",self,"saveAtSlot",[2])
	slot3.connect("button_down",self,"saveAtSlot",[3])
	slot4.connect("button_down",self,"saveAtSlot",[4])
	slot5.connect("button_down",self,"saveAtSlot",[5])
	slot6.connect("button_down",self,"saveAtSlot",[6])
	slot7.connect("button_down",self,"saveAtSlot",[7])
	slot8.connect("button_down",self,"saveAtSlot",[8])
	slot9.connect("button_down",self,"saveAtSlot",[9])
	slot10.connect("button_down",self,"saveAtSlot",[10])
	back_button.connect("button_down",self,"nextScene",["SaveLoad"])
