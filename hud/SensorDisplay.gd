extends "res://hud/SensorDisplay.gd"

#var dir = Directory.new()
#var file = File.new()
#var scannerdir = "user://cache/.ExternalHUD_Cache/text_sensors/"

onready var Network = get_tree().get_root().get_node_or_null("ExternalHUD_Network")

export var can_scan = true

func _ready():
	if can_scan:
		connect("tree_exiting",self,"exiter")
	

var has_rendered = false

func _process(delta):
	if can_scan and reader:
#		var current = {"name":sensor,"data":text,"color":self_modulate}
#
#		file.open(scannerdir + "sensor_%s" % sensor,File.WRITE)
#		file.store_string(JSON.print(current))
#		file.close()
		
		Network.update_text_sensor(sensor,text)
		
		has_rendered = true

func exiter():
	can_scan = false
	if has_rendered:
		Network.wipe_sensor(sensor)
#		dir.remove(scannerdir + "sensor_%s_A" % sensor)
#		dir.remove(scannerdir + "sensor_%s_B" % sensor)
