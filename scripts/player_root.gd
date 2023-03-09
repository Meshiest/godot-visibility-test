extends Node

@export var player: CharacterBody3D

func _enter_tree():
  player.set_multiplayer_authority(str(name).to_int())
