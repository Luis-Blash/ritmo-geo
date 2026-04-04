extends Control

# --- Referencias a nodos de UI ---
@onready var lives_label      = $HUD/LivesLabel
@onready var score_label      = $HUD/ScoreLabel
@onready var pause_screen     = $PauseScreen
@onready var game_over_screen = $GameOverScreen
@onready var restart_button   = $GameOverScreen/RestartButton

func _ready() -> void:
	# conecta señales del GameManager
	GameManager.on_lives_changed.connect(_on_lives_changed)
	GameManager.on_score_changed.connect(_on_score_changed)
	GameManager.on_pause.connect(_on_pause)
	GameManager.on_game_over.connect(_on_game_over)

	# conecta el botón de restart
	restart_button.pressed.connect(_on_restart)

	# estado inicial — ambas pantallas ocultas
	pause_screen.visible     = false
	game_over_screen.visible = false

	# muestra valores iniciales
	_update_lives(GameManager.player.lives)
	_update_score(GameManager.player.score)

# --- Vidas ---
func _on_lives_changed(new_lives: int) -> void:
	_update_lives(new_lives)

func _update_lives(lives: int) -> void:
	lives_label.text = "Vidas: " + str(lives)

# --- Score ---
func _on_score_changed(new_score: int) -> void:
	_update_score(new_score)

func _update_score(score: int) -> void:
	score_label.text = "Score: " + str(score)

# --- Pausa ---
func _on_pause(is_paused: bool) -> void:
	pause_screen.visible = is_paused
	if is_paused:
		game_over_screen.visible = false

# --- Game Over ---
func _on_game_over() -> void:
	game_over_screen.visible = true
	pause_screen.visible     = false
	_update_lives(0)

# --- Restart ---
func _on_restart() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
