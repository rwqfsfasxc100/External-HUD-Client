extends "res://ships/ship-ctrl.gd"

var can = true
var count = 0
var toggle = true

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


var dirv3 = Directory.new()
var filev3 = File.new()
var scannerdir = "user://cache/.ExternalHUD_Cache/text_sensors/sensors_%s"
var rendered = false

func _ready():
	can = isPlayerControlled()
	dirv3.make_dir_recursive(scannerdir)
	connect("tree_exiting",self,"exiter")

func _physics_process(delta):
	count += 1
	if can and count % 4 == 0:
		
		var sensor_data = {}
		var extension = "A" if toggle else "B"
		for sensor in sensors:
			var got = sensorGet(sensor)
			sensor_data[sensor] = got
		filev3.open(scannerdir % extension,File.WRITE)
		filev3.store_string(var2str(sensor_data))
		filev3.close()
		rendered = true
		count = 0
#		toggle = !toggle

func exiter():
	can = false
	if rendered:
		dirv3.remove(scannerdir % "A")
		dirv3.remove(scannerdir % "B")
