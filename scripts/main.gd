extends Node

var peer = ENetMultiplayerPeer.new()
const PORT = 3003

@onready var players = %Players
const PlayerScene = preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if peer.create_server(PORT) == OK:
    multiplayer.peer_connected.connect(add_player)
    multiplayer.peer_disconnected.connect(remove_player)

    if DisplayServer.get_name() != "headless":
      await get_tree().create_timer(.2).timeout
      add_player(1)

  else:
    peer.create_client("127.0.0.1", PORT)

  multiplayer.multiplayer_peer = peer

func add_player(id: int) -> void:
  var player := PlayerScene.instantiate()
  player.name = str(id)
  players.add_child(player)

func remove_player(id: int) -> void:
  var player := players.get_node(str(id))
  if player: player.queue_free()
