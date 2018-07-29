extends Control

onready var host_button = $HostJoinMenu/VBOX/HostButton
onready var join_button = $HostJoinMenu/VBOX/JoinButton
onready var back_button = $HostJoinMenu/VBOX/BackButtton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	host_button.connect("button_down",self,"nextScene",["Host"])
	join_button.connect("button_down",self,"nextScene",["Join"])
	back_button.connect("button_down",self,"nextScene",["Main"])
