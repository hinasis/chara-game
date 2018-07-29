extends Control

func nextScene():
	get_node("/root/global").delayNextScene("Lobby")

func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("mouse_left"):
		accept_event()
		nextScene()
