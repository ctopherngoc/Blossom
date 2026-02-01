extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 2736

@onready var server = get_node("/root/Server")
	
func connect_to_server() -> void:
	print("attempting to connect to game server hub")
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network

	network.connect("connection_failed", Callable(self, "_OnConnectionFailed"))
	network.connect("connection_succeeded", Callable(self, "_OnConnectionSucceeded"))

func _OnConnectionFailed() -> void:
	print("Failed to connect to Game Server Hub")

func _OnConnectionSucceeded() -> void:
	print("Successfully connected to Game Server Hub")

@rpc("any_peer") func received_login_token(token):
	server.expected_tokens.append(token)
