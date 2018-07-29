extends Control

onready var back_button = $InputArea/VBOX/HBOX/BackButton
onready var next_button = $InputArea/VBOX/HBOX/NextButton
onready var username_input = $InputArea/VBOX/UsernameInput

func changeScene(to):
	if to == "back":
		get_node("/root/global").delayNextScene("Lobby")
	elif to == "next":
		if username_input.text.length() >2:
			get_node("/root/global").delayNextScene("Main")
		else:
			print("username must be three(3) length at least")

func _ready():
	username_input.grab_focus()
	back_button.connect("button_down",self,"changeScene",["back"])
	next_button.connect("button_down",self,"changeScene",["next"])

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		changeScene("next")