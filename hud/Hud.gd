extends "res://hud/Hud.gd"

var dir = Directory.new()
var file = File.new()
var scannerdir = "user://cache/.ExternalHUD_Cache/text_sensors/"

func _ready():
	dir.make_dir_recursive("user://cache/.ExternalHUD_Cache/text_sensors/")
	connect("tree_exiting",self,"exiter")


var sensors = [
	"cargo.value",
	"return.fuel",
	"return.fuel.xenon",
	"return.time",
	"return.time.xenon",
	"mass",
	"fuel",
	"fuel.special",
	"ammo",
	"drones",
	"cargoMass",
	"cargoCapacity",
	"power_balance",
	"power_draw",
	"power_supply",
	"internalCapacitor",
	"internalCapacitor.capacity",
	"capacitor",
	"diveDepth",
	"reactor_temperature",
	"reactor_temperature/1",
	"reactor_temperature/2",
	"velocity",
	"acceleration",
	"bearing",
	"orientation",
	"escape_trajectory",
	"trajectory",
	"dv",
	"status",
	"rw_rpm",
	"proximityAlert",
	"proximityAlert.astrogation",
	"autopilot.velocity",
	"autopilot.bearing",
	"autopilot.orientation",
	"autopilot.acceleration",
	"temporaryCargo.weapon-left-back",
	"temporaryCargo.weapon-left-back2",
	"temporaryCargo.weapon-left-back3",
	"temporaryCargo.weapon-right-back",
	"temporaryCargo.weapon-right-back2",
	"temporaryCargo.weapon-right-back3",
]

var count = 0
var can = true
var has_rendered = false

var toggle = true

func _physics_process(delta):
	count += 1
	if can and count % 4 == 0:
		for sensor in sensors:
			var current = {"name":sensor,"data":getSensorReadout(sensor)}
		
			file.open(scannerdir + "sensor_%s" % sensor,File.WRITE)
			file.store_string(JSON.print(current))
			file.close()
		has_rendered = true
		count = 0
#		toggle = !toggle

func exiter():
	can = false
	if has_rendered:
		for sensor in sensors:
			dir.remove(scannerdir + "sensor_%s" % sensor)
			
