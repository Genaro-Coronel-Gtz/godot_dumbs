extends Node

# Configuración del pool
const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const POOL_SIZE = 10  # Cantidad inicial de enemigos en el pool

var enemy_pool: Array[CharacterBody3D] = []
var active_enemies: Array[CharacterBody3D] = []

func _ready():
	# Crear todos los enemigos al inicio
	for i in range(POOL_SIZE):
		var enemy = ENEMY_SCENE.instantiate()
		enemy.visible = false
		enemy.set_physics_process(false)
		get_tree().root.get_node("Main").add_child(enemy)
		enemy_pool.push_back(enemy)

func get_enemy() -> CharacterBody3D:
	var enemy: CharacterBody3D
	
	if enemy_pool.is_empty():
		# Si no hay enemigos disponibles, crear uno nuevo
		enemy = ENEMY_SCENE.instantiate()
		get_tree().root.get_node("Main").add_child(enemy)
		print("Pool expandido: creando nuevo enemigo")
	else:
		# Obtener un enemigo del pool
		enemy = enemy_pool.pop_back()
	
	# Activar el enemigo
	enemy.visible = true
	enemy.set_physics_process(true)
	enemy.activate()
	
	# Agregarlo a la lista de activos
	active_enemies.push_back(enemy)
	
	return enemy

func return_enemy(enemy: CharacterBody3D) -> void:
	# Remover activos
	if enemy in active_enemies:
		active_enemies.erase(enemy)
	
	# Desactivar y resetear
	enemy.deactivate()
	enemy.visible = false
	enemy.set_physics_process(false)
	
	# Devolver al pool
	enemy_pool.push_back(enemy)

func get_pool_stats() -> Dictionary:
	return {
		"available": enemy_pool.size(),
		"active": active_enemies.size(),
		"total": enemy_pool.size() + active_enemies.size()
	}
