extends Node

var sa = []
func _init():
	var STRUCTURE = {names="",size="",solid=false,hp="",collection=""}
	#-----------------------------#
	STRUCTURE.names = ["mountain"]
	STRUCTURE.size = "big"
	STRUCTURE.insides = 0
	STRUCTURE.hp = 100
	STRUCTURE.collection = "test"
	STRUCTURE.cost = {hate=0,love=0,kawaii=0,gore=0}
	sa.append(STRUCTURE.duplicate())
	#-----------------------------#
	STRUCTURE.names = ["cave"]
	STRUCTURE.size = "small"
	STRUCTURE.insides = 2
	STRUCTURE.hp = 20
	STRUCTURE.collection = "test"
	STRUCTURE.cost = {hate=0,love=0,kawaii=0,gore=0}
	sa.append(STRUCTURE.duplicate())
	#-----------------------------#
	STRUCTURE.names = ["rock"]
	STRUCTURE.size = "small"
	STRUCTURE.insides = 0
	STRUCTURE.hp = 10
	STRUCTURE.collection = "test"
	STRUCTURE.cost = {hate=0,love=0,kawaii=0,gore=0}
	sa.append(STRUCTURE.duplicate())
	#-----------------------------#
	STRUCTURE.names = ["forest"]
	STRUCTURE.size = "big"
	STRUCTURE.insides = 0
	STRUCTURE.hp = 100
	STRUCTURE.collection = "test"
	STRUCTURE.cost = {hate=0,love=0,kawaii=0,gore=0}
	sa.append(STRUCTURE.duplicate())
	#-----------------------------#
	STRUCTURE.names = ["hut"]
	STRUCTURE.size = "small"
	STRUCTURE.insides = 2
	STRUCTURE.hp = 20
	STRUCTURE.collection = "test"
	STRUCTURE.cost = {hate=0,love=0,kawaii=0,gore=0}
	sa.append(STRUCTURE.duplicate())
	#-----------------------------#
	STRUCTURE.names = ["bush"]
	STRUCTURE.size = "small"
	STRUCTURE.insides = 0
	STRUCTURE.hp = 10
	STRUCTURE.collection = "test"
	STRUCTURE.cost = {hate=0,love=0,kawaii=0,gore=0}
	sa.append(STRUCTURE.duplicate())
