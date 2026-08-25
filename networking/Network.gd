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

extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 28641

export var reconnect_delay = 3

func _ready():
	var timer = Timer.new()
	timer.wait_time = reconnect_delay
	timer.one_shot = true
	timer.name = "HUDTIMER"
	timer.connect("ready",self,"start_timer")
	timer.connect("timeout",self,"recheck")
	call_deferred("add_child",timer)
	get_tree().connect("server_disconnected",self,"_disconnected")
	get_tree().connect("connection_failed",self,"_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	connect_to_server()

var connected = false

var hudTimer

func start_timer():
	if not hudTimer:
		hudTimer = get_node_or_null("HUDTIMER")
	if hudTimer:
		hudTimer.start()

func recheck():
	if not connected:
		connect_to_server()
		start_timer()

func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP,DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	connected = true

func _disconnected():
	connected = false
	start_timer()

func add_text_sensor(sensor):
	if connected:
		rpc("update_sensor",sensor,"text","------")

func update_text_sensor(sensor,value):
	if connected:
		rpc("update_sensor",sensor,"text",value)

func add_visual_sensor(sensor):
	if connected:
		rpc("update_sensor",sensor,"visual",PoolByteArray())

func update_visual_sensor(sensor,value):
	if connected:
		rpc("update_sensor",sensor,"visual",value)

func wipe_sensor(sensor):
	if connected:
		rpc("wipe_sensor",sensor)
