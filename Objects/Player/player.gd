extends CharacterBody3D

@onready var hitbox = $Area3D
@export var JUMP_VELOCITY:float = 5.0
@export var LANE_DISTANCE:float = 3.0  # distancia en unidades entre cada carril
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_lane:int = 0
var alive:bool = true

func _ready():
	hitbox.area_entered.connect(_on_hit)
	GameManager.player.current_lane = current_lane

func _physics_process(delta: float) -> void:
	if GameManager.is_stopped():
		return

	# GRAVEDAD
	if not is_on_floor():
		velocity.y -= gravity * delta

	# SALTO
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# CAMBIO DE CARRIL — limita entre -1 y 1
	if Input.is_action_just_pressed("move_left"):
		current_lane = max(current_lane - 1, -1)
	if Input.is_action_just_pressed("move_right"):
		current_lane = min(current_lane + 1, 1)

	GameManager.player.current_lane = current_lane
	# MOVIMIENTO LATERAL SUAVE — interpola hacia el carril objetivo
	var target_x = current_lane * LANE_DISTANCE
	velocity.x = lerp(velocity.x, (target_x - position.x) * 10.0, delta * 8.0)
	move_and_slide()

func _on_hit(area):
	if area.is_in_group("damage"):
		die()

func die():
	GameManager.take_damage()
