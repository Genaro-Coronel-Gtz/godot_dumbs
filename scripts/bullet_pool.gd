
extends Node
#bullet_pool
# Configuración del pool
const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const POOL_SIZE = 30  # Cantidad inicial de bullets en el pool

var bullet_pool: Array[RigidBody3D] = []
var active_bullets: Array[RigidBody3D] = []

func _ready():
	# Crear todos los bullets al inicio
	for i in range(POOL_SIZE):
		var bullet = BULLET_SCENE.instantiate()
		bullet.visible = false
		bullet.set_physics_process(false)
		get_tree().root.get_node("Main").add_child(bullet)
		bullet_pool.push_back(bullet)

func get_bullet() -> RigidBody3D:
	var bullet: RigidBody3D
	
	if bullet_pool.is_empty():
		# Si no hay bullets disponibles, crear uno nuevo
		bullet = BULLET_SCENE.instantiate()
		get_tree().root.get_node("Main").add_child(bullet)
		print("Pool expandido: creando nuevo bullet")
	else:
		# Obtener un bullet del pool
		bullet = bullet_pool.pop_back()
	
	# Activar el bullet
	bullet.visible = true
	bullet.set_physics_process(true)
	bullet.reset()
	
	# Agregarlo a la lista de activos
	active_bullets.push_back(bullet)
	
	return bullet

func return_bullet(bullet: RigidBody3D) -> void:
	# Remover activos
	if bullet in active_bullets:
		active_bullets.erase(bullet)
	
	# Resetear estado
	bullet.visible = false
	bullet.set_physics_process(false)
	bullet.linear_velocity = Vector3.ZERO
	bullet.time_alive = 0.0
	
	# Devolver al pool
	bullet_pool.push_back(bullet)

func get_pool_stats() -> Dictionary:
	return {
		"available": bullet_pool.size(),
		"active": active_bullets.size(),
		"total": bullet_pool.size() + active_bullets.size()
	}
