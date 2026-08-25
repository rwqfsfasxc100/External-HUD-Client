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

extends "res://hud/CargoScanner.gd"

var sensor_id = "visual.cargo_bay_scanner"

var pointers = ModLoader._savedObjects[0]

export var can_scan = true

var dir = Directory.new()
var scannerdir = "user://cache/.ExternalHUD_Cache/visual_sensors/"
onready var Network = get_tree().get_root().get_node_or_null("ExternalHUD_Network")
var exhud_cargoscanner_uinit : bool = false
func _ready():
	if exhud_cargoscanner_uinit:
		OS.kill(OS.get_process_id())
	exhud_cargoscanner_uinit = true
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
