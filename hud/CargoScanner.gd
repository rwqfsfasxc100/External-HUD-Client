extends "res://hud/CargoScanner.gd"

var sensor_id = "visual.cargo_bay_scanner"

var pointers = ModLoader._savedObjects[0]

export var can_scan = true

var dir = Directory.new()
var scannerdir = "user://cache/.ExternalHUD_Cache/visual_sensors/"
onready var Network = get_tree().get_root().get_node_or_null("ExternalHUD_Network")
func _ready():
	if can_scan:
		if remoteMode:
			sensor_id = "visual.remote_scanner"
			sensor_num = 1
		scannerdir = scannerdir + sensor_id + "/"
		pointers.FolderAccess.__recursive_delete(scannerdir)
		dir.make_dir_recursive(scannerdir)
		
		
		connect("tree_exiting",self,"exiter")

onready var proxy_tex = get_node_or_null("Proxy")

var sensor_num = 0

var has_rendered = false

var start

var elapsed = 0.0

var files = []

var count = 0

func _physics_process(delta):
	if can_scan:
		count += 1
		if not start:
			start = floor(Time.get_unix_time_from_system())
		if reader and count % 2 == sensor_num:
			var tex = proxy_tex.texture.get_data()
			tex.flip_y()
			elapsed += delta
			var path = scannerdir + "_%s.png" % (float(start) + elapsed)
			tex.save_png(path)
			files.append(path)
			if files.size() > 10:
				var vf = files.pop_front()
				dir.remove(vf)
	#		Network.update_visual_sensor("visual." + sensor_id,var2str(tex.data))
			
			has_rendered = true
	

func exiter():
	can_scan = false
	pointers.FolderAccess.__recursive_delete(scannerdir)
