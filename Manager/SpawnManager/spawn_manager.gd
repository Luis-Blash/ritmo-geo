extends Node3D

# --- Referencias (asignar en el Inspector) ---
@export var damage_section: PackedScene
@onready var obstacles: Node3D = $Obstacles
var player: Node3D

# --- Configuración de spawn ---
@export var spawn_interval: float = 2.5
@export var section_speed:  float = 6.0

# --- Estado interno ---
var timer = 0.0
var can_spawn = true

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if not can_spawn:
		return
#
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		_spawn_section()

func _spawn_section():
	if not damage_section:
		push_error("SpawnManager: arrastra damage_section.tscn al Inspector")
		return
		
	var section = damage_section.instantiate()
	obstacles.add_child(section) 
	
	section.global_position = Vector3(
		0.0,
		0.0,
		global_position.z
	)

	section.speed = section_speed
