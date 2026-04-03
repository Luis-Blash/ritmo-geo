extends Node

# --- Clase que define los datos del player ---
class PlayerData:
	var lives: int = 3
	var score: int = 0
	var current_lane: int = 0

# --- Estado del juego ---
var paused: bool = false
var game_over: bool = false
var player := PlayerData.new()

# --- Señales ---
signal on_pause(is_paused: bool)
signal on_game_over
signal on_lives_changed(new_lives: int)
signal on_score_changed(new_score: int)

# --- Métodos de pausa ---
func pause():
	paused = true
	emit_signal("on_pause", true)

func resume():
	paused = false
	emit_signal("on_pause", false)

# --- Métodos del player ---
func take_damage():
	player.lives -= 1
	emit_signal("on_lives_changed", player.lives)
	if player.lives <= 0:
		trigger_game_over()

func add_score(points: int):
	player.score += points
	emit_signal("on_score_changed", player.score)

func trigger_game_over():
	game_over = true
	emit_signal("on_game_over")

# --- PAUSE ---
func hasPauseGame():
	return paused or game_over
# --- Reset ---
func reset():
	paused = false
	game_over = false
	player = PlayerData.new()  # crea una instancia limpia
