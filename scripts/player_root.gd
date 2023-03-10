class_name PlayerRoot
extends Node

@export var player: CharacterBody3D
@export var host_sync: MultiplayerSynchronizer
@export var peer_sync: MultiplayerSynchronizer
@export var player_id: int

func _enter_tree():
  var id := str(name).to_int()
  print_debug("(%d) enter tree %d, %d" % [multiplayer.get_unique_id(), id, player_id])
  player.set_multiplayer_authority(id)
  host_sync.set_visibility_for(id, true)
  peer_sync.set_visibility_for(1, true)
