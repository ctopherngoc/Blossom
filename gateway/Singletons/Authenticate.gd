extends Node

var network = ENetMultiplayerPeer.new()
var port = 2735
var ip = "127.0.0.1"

func _ready():
	connect_to_server()
	
func connect_to_server():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	
	match network.get_connection_status():
		MultiplayerPeer.CONNECTION_CONNECTED:
			print("Successfully connected to authentication server")
		MultiplayerPeer.CONNECTION_DISCONNECTED:
			print("Disconnected from authentication server")
	
func _OnConnectionDisconnect():
	print("Disconnected from authentication server")
	
func _OnConnectionFailed():
	print("Failed to connect to authentication server")

func _OnConnectionSucceeded():
	print("Successfully connected to authentication server")
	
@rpc("any_peer") func authenticate_player(username, password, player_id):
	print("sending out authentication request")
	rpc_id(1, "authenticate_player", username, password, player_id)
	
@rpc("any_peer") func authentication_results(result, player_id):
	print("resuts received and replying to player login request")
	Gateway.return_login_request(result, player_id)
