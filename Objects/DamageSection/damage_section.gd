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


func _process(delta):
	if not active:
		return

	# se mueve hacia el player
	position.z += speed * delta

	# se autodestruye al pasar al jugador
	if position.z > 5.0:
		queue_free()
		
func _randomize_lanes():
	# decide cuántos carriles bloquear: 1 o 2 (nunca 3)
	var lanes = [cube_left, cube_center, cube_right]
	lanes.shuffle()

	# cantidad de cubos a mostrar (1 o 2 bloqueados)
	var blocked = randi_range(1, 2)

	for i in range(lanes.size()):
		# muestra solo los primeros "blocked" cubos
		lanes[i].visible = i < blocked
		# desactiva colision si no es visible
		lanes[i].use_collision = i < blocked
