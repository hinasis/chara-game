extends Node

var ba = []
func _init():
	var BAND = {names="",collection=""}
	#----------------------------#
	BAND.names = ["wind"]
	BAND.collection = "test"
	ba.append(BAND.duplicate())
	#----------------------------#
	BAND.names = ["string"]
	BAND.collection = "test"
	ba.append(BAND.duplicate())
	#----------------------------#
	BAND.names = ["percussion"]
	BAND.collection = "test"
	ba.append(BAND.duplicate())
	#----------------------------#
	BAND.names = ["electric"]
	BAND.collection = "test"
	ba.append(BAND.duplicate())
