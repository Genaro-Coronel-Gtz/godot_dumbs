extends Node

# Configuración de spawn
const SPAWN_INTERVAL = 3.0  # Segundos entre spawns
const MAX_ACTIVE_ENEMIES = 5  # Máximo de enemigos activos simultáneamente
const SPAWN_POSITIONS = [
	Vector3(-8, 1.25, -8),
	Vector3(8, 1.25, -8),
	Vector3(-8, 1.25, 8),
	Vector3(8, 1.25, 8),
	Vector3(-10, 1.25, 0),
]

var spawn_timer = 0.0
var spawn_index = 0

func _physics_process(delta):
	spawn_timer += delta
	
	if spawn_timer >= SPAWN_INTERVAL:
		# Spawnar solo si no hay demasiados enemigos activos
		if EnemyPool.active_enemies.size() < MAX_ACTIVE_ENEMIES:
			spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy() -> void:
	var enemy = EnemyPool.get_enemy()
	
	# Asignar posición de spawn (rotar entre las predefinidas)
	var spawn_pos = SPAWN_POSITIONS[spawn_index % SPAWN_POSITIONS.size()]
	enemy.global_position = spawn_pos
	
	spawn_index += 1
	
	print("Enemigo spawneado en: ", spawn_pos, " (Activos: ", EnemyPool.active_enemies.size(), ")")
