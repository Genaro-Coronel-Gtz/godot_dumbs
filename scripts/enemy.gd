extends CharacterBody3D

const FIRE_RATE = 1.0  # segundos entre disparos
const FIRE_RANGE = 15.0  # Distancia máxima para disparar

var time_since_last_shot = 0.0
var player: Node3D
var spawn_position: Vector3 = Vector3.ZERO

func _ready():
	# No buscar el player aquí, se hace en activate()
	pass

func activate() -> void:
	"""Activa el enemigo y lo prepara para jugar"""
	player = get_tree().root.get_node("Main/Player")
	reset()

func deactivate() -> void:
	"""Desactiva el enemigo y lo prepara para volver al pool"""
	player = null

func reset() -> void:
	"""Reinicia el estado del enemigo para reutilización"""
	time_since_last_shot = 0.0
	velocity = Vector3.ZERO

func _physics_process(delta):
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		# Dispara solo si el player está dentro del rango
		if distance_to_player <= FIRE_RANGE:
			# Hacer que el enemigo mire hacia el player
			look_at(player.global_position + Vector3(0, 0.5, 0), Vector3.UP)
			
			# Actualizar tiempo desde el último disparo
			time_since_last_shot += delta
			
			# Disparar cuando haya pasado el fire rate
			if time_since_last_shot >= FIRE_RATE:
				shoot()
				time_since_last_shot = 0.0
		else:
			# Reset del timer si el player se aleja
			time_since_last_shot = 0.0

func shoot():
	# Tipo de bullet disparar (50% normal, 50% azul)
	var bullet_type = BulletPool.BulletType.NORMAL if randi_range(0, 2) == 0 else BulletPool.BulletType.BLUE
	
	var bullet_instance = BulletPool.get_bullet(bullet_type)
	var spawn_point = get_node("BulletSpawnPoint")
	
	# Establecer la posicion global
	bullet_instance.global_position = spawn_point.global_position
	# Capturar la posicion del player en este momento
	# El player tiene altura 2.0, asi que su centro está a 1.0 unidades arriba
	var target_position = player.global_position + Vector3(0, 1.0, 0)

	# Disparar el bullet (el método fire decide si es lineal o parabólico según el tipo)
	bullet_instance.fire(target_position)
	#print("Bullet disparado: origen=", bullet_instance.global_position, " objetivo=", target_position)
