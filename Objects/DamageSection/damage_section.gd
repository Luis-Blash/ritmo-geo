extends Node3D


# velocidad a la que viene hacia el jugador
@export var speed = 8.0

# referencia a los 3 cubos
@onready var cube_left   = $CubeLeft
@onready var cube_center = $CubeCenter
@onready var cube_right  = $CubeRight
var active = true  # se pausa desde afuera


func _ready():
	_randomize_lanes()
	GameManager.on_pause.connect(_on_game_paused)


func _process(delta):
	if not active:
		return
		
	position.z += speed * delta

	# compara global_position para que funcione sin importar dónde esté el padre
	if global_position.z > 5.0:
		queue_free()
		
func _randomize_lanes():
	var lanes = [cube_left, cube_center, cube_right]
	lanes.shuffle()
	var blocked = randi_range(1, 2)
	for i in range(lanes.size()):
		lanes[i].visible = i < blocked
		# Area3D usa monitorable en vez de use_collision
		lanes[i].monitorable = i < blocked
		lanes[i].monitoring = i < blocked
		
func _on_game_paused(is_paused: bool):
	active = !is_paused
