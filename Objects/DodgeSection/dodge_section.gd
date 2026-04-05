extends Node3D

@export var speed: float = 8.0

@onready var wall_left   = $WallLeft
@onready var wall_center = $WallCenter
@onready var wall_right  = $WallRight

var active: bool = true

func _ready() -> void:
	_randomize_gap()
	GameManager.on_pause.connect(_on_game_paused)

func _process(delta: float) -> void:
	if not active:
		return

	position.z += speed * delta

	if global_position.z > 5.0:
		queue_free()

func _randomize_gap() -> void:
	var walls = [wall_left, wall_center, wall_right]
	var free_lane = randi() % walls.size()
	for i in range(walls.size()):
		var is_free = i == free_lane
		walls[i].visible      = !is_free
		walls[i].monitorable  = !is_free
		walls[i].monitoring   = !is_free

func _on_game_paused(is_paused: bool) -> void:
	active = !is_paused
