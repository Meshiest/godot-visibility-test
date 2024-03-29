extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var sync: MultiplayerSynchronizer
@export var host_sync: MultiplayerSynchronizer
@onready var name_label := $NameLabel

func _ready():
  name_label.text = get_label_name()
  host_sync.set_visibility_for(1, true)
  sync.set_visibility_for(1, true)


func get_label_name() -> String:
  # the server can determine which players are clients
  if multiplayer.get_unique_id() == 1:
    if is_multiplayer_authority(): return "[server] %s (%s)" % [get_parent().name, get_visibility()]
    return "[client] %s" % get_parent().name

  # clients can see their own visibility
  if is_multiplayer_authority(): return "[me] %s (%s)" % [get_parent().name, get_visibility()]

  # peers just see a name
  return get_parent().name

func get_visibility() -> String:
  if sync.public_visibility: return "public"
  return "private"

@rpc("call_local")
func jump(v: bool):
  host_sync.set_visibility_for(0, v)
  sync.set_visibility_for(0, v)
  name_label.text = get_label_name()

func _physics_process(delta):
  if not is_multiplayer_authority(): return
  if get_parent().name != str(multiplayer.get_unique_id()): return

  if not is_on_floor():
    velocity.y -= gravity * delta

  if Input.is_action_just_pressed("jump") and is_on_floor():
    jump.rpc(not sync.public_visibility)

    velocity.y = JUMP_VELOCITY

  var input_dir = Input.get_vector("left", "right", "up", "down")
  var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()
