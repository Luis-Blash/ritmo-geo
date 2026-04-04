extends Node3D

# --- Secciones disponibles (arrastra las .tscn aquí en el Inspector) ---
@export var sections: Array[PackedScene]

@onready var obstacles: Node3D = $Obstacles
var player: Node3D

# --- Configuración ---
@export var spawn_interval: float = 2.5
@export var section_speed: float = 6.0

# --- Estado interno ---
var timer: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	GameManager.on_pause.connect(_on_game_paused)
	GameManager.on_game_over.connect(_on_game_over)

func _process(delta):
	if GameManager.is_stopped():
		return
	
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		_spawn_section()

func _spawn_section():
	if sections.is_empty():
		push_error("SpawnManager: no hay secciones asignadas en el Inspector")
		return

	# elige una seccion al azar del array
	var random_section = sections[randi() % sections.size()]
	var section = random_section.instantiate()

	obstacles.add_child(section)
	section.global_position = Vector3(0.0, 0.0, global_position.z)
	section.speed = section_speed

func _on_game_paused(is_paused: bool):
	for obs in obstacles.get_children():
		obs.active = !is_paused

func _on_game_over():
	for obs in obstacles.get_children():
		obs.queue_free()
