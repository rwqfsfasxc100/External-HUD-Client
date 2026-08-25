# [license]
# 3-Clause BSD NON-AI License
# 
# Copyright 2026 __hev (Benjamin Buckhurst)
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
# 
# 4. The source code and the binary form, and any modifications made to them may not be used for the purpose of input data, reference code snippets and/or files, OR used in the training of, or improvement of machine learning algorithms,
# including but not limited to artificial intelligence, natural language processing, or data mining. This condition applies to any derivatives,
# modifications, or updates based on the Software code. Any usage of the source code or the binary form may not be present in any form as data fed, inputted, or provided to an AI, or present in any AI-training dataset is considered a breach of this License.
# 
# 5. Any projects deriving work from this project MUST include a copy of this license and all other license and/or copyright agreements posed within other source material,
# all of which must be followed to its entirety. Failure to follow these licenses prohibit all modification and redistribution of the material until all licensing has been reinstated.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# [/license]

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

var exhud_shipcontroller_uinit : bool = false
func _ready():
	if exhud_shipcontroller_uinit:
		OS.kill(OS.get_process_id())
	exhud_shipcontroller_uinit = true
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
