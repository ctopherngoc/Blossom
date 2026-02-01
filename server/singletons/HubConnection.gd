extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 2736

@onready var server = get_node("/root/Server")
	
func connect_to_server() -> void:
	print("attempting to connect to game server hub")
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	
	match network.get_connection_status():
		MultiplayerPeer.CONNECTION_CONNECTED:
			print("Successfully connected to Game Server Hub")
		MultiplayerPeer.CONNECTION_DISCONNECTED:
			print("Disconnected from Game Server Hub")

@rpc("any_peer") func received_login_token(token):
	server.expected_tokens.append(token)
