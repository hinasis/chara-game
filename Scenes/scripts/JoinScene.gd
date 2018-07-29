extends Control

onready var address_input = $JoinMenu/VBOX/AddressInput
onready var ip_input =  $JoinMenu/VBOX/IPInput
onready var back_button = $JoinMenu/VBOX/HBOX/BackButton
onready var join_button = $JoinMenu/VBOX/HBOX/JoinButton

func nextScene(to):
	if to == "back":
		get_node("/root/global").delayNextScene("HostJoin")
	elif to == "join":
		if address_input.text.length() > 0 and ip_input.text.length() > 0:
			get_node("/root/global").delayNextScene("HostJoin")
		else:
			print("you must provide an address and a ip in order to join")

func _ready():
	address_input.grab_focus()
	back_button.connect("button_down",self,"nextScene",["back"])
	join_button.connect("button_down",self,"nextScene",["join"])

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		nextScene("join")