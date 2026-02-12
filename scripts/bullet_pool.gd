
extends Node
#bullet_pool
# Enum para tipos de bullets
enum BulletType {
	NORMAL,
	BLUE
}

# Configuración del pool
const BULLET_BLUE_SCENE = preload("res://scenes/bullet_blue.tscn")
const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const POOL_SIZE = 30  # Cantidad inicial de bullets en el pool (por tipo)

var bullet_pool: Array[RigidBody3D] = []
var bullet_blue_pool: Array[RigidBody3D] = []
var active_bullets: Array[RigidBody3D] = []

func _ready():
	# Crear bullets normales al inicio
	for i in range(POOL_SIZE):
		var bullet = BULLET_SCENE.instantiate()
		bullet.visible = false
		bullet.set_physics_process(false)
		get_tree().root.get_node("Main").add_child(bullet)
		bullet_pool.push_back(bullet)
	
	# Crear bullets azules al inicio
	for i in range(POOL_SIZE):
		var bullet = BULLET_BLUE_SCENE.instantiate()
		bullet.visible = false
		bullet.set_physics_process(false)
		get_tree().root.get_node("Main").add_child(bullet)
		bullet_blue_pool.push_back(bullet)

func get_bullet(bullet_type: BulletType = BulletType.NORMAL) -> RigidBody3D:
	var bullet: RigidBody3D
	var pool: Array[RigidBody3D]
	var scene: PackedScene
	
	# Seleccionar el pool y escena según el tipo
	match bullet_type:
		BulletType.NORMAL:
			pool = bullet_pool
			scene = BULLET_SCENE
		BulletType.BLUE:
			pool = bullet_blue_pool
			scene = BULLET_BLUE_SCENE
	
	if pool.is_empty():
		# Si no hay bullets disponibles, crear uno nuevo
		bullet = scene.instantiate()
		get_tree().root.get_node("Main").add_child(bullet)
		print("Pool expandido: creando nuevo bullet tipo ", BulletType.keys()[bullet_type])
	else:
		# Obtener un bullet del pool
		print(" se retorna bullet del pool")
		bullet = pool.pop_back()
	
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
	
	# Devolver al pool correspondiente (detectar por nombre de nodo)
	if bullet.name == "BulletBlue":
		bullet_blue_pool.push_back(bullet)
	else:
		bullet_pool.push_back(bullet)

func get_pool_stats() -> Dictionary:
	return {
		"normal_available": bullet_pool.size(),
		"blue_available": bullet_blue_pool.size(),
		"active": active_bullets.size(),
		"total": bullet_pool.size() + bullet_blue_pool.size() + active_bullets.size()
	}
