extends Node3D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const FIRE_RATE = 1.0  # segundos entre disparos
const GRAVITY = 9.8
const FLIGHT_TIME = 1.5  # Tiempo de vuelo para una trayectoria más precisa

var time_since_last_shot = 0.0
var player: Node3D

func _ready():
	player = get_tree().root.get_node("Main/Player")

func _physics_process(delta):
	if player:
		# Hacer que el enemigo mire hacia el player
		look_at(player.global_position + Vector3(0, 0.5, 0), Vector3.UP)
		
		# Actualizar tiempo desde el último disparo
		time_since_last_shot += delta
		
		# Disparar cuando haya pasado el fire rate
		if time_since_last_shot >= FIRE_RATE:
			shoot()
			time_since_last_shot = 0.0

func calculate_ballistic_velocity(from: Vector3, to: Vector3, gravity: float) -> Vector3:
	"""Calcula la velocidad inicial necesaria para que un proyectil llegue a un objetivo
	usando una trayectoria parabólica con gravedad."""
	var diff = to - from
	
	if diff.length() < 0.1:
		return Vector3(0, 0, 0)
	
	var flight_time = FLIGHT_TIME
	
	# Calcular velocidades necesarias para cubrir la distancia en ese tiempo
	var velocity = diff / flight_time
	
	# Ajustar vy considerando la gravedad
	# Ecuación: y_final = y_initial + vy*t - 0.5*g*t²
	# Despejando vy: vy = (diff.y + 0.5*g*t²) / t
	var vy = (diff.y + 0.5 * gravity * flight_time * flight_time) / flight_time
	velocity.y = vy
	
	return velocity

func shoot():
	var bullet_instance = BULLET_SCENE.instantiate()
	var spawn_point = get_node("BulletSpawnPoint")
	
	# Primero agregar al árbol
	get_tree().root.get_node("Main").add_child(bullet_instance)
	
	# Luego establecer la posición global
	bullet_instance.global_position = spawn_point.global_position
	
	# Capturar la posición del player en este momento
	# El player tiene altura 2.0, así que su centro está a 1.0 unidades arriba
	var target_position = player.global_position + Vector3(0, 1.0, 0)

	# Usar la API pública del bullet para lanzarlo (desacopla cálculo)
	if bullet_instance.has_method("launch"):
		bullet_instance.launch(target_position, FLIGHT_TIME)
	else:
		# Fallback: calcular localmente
		var ballistic_velocity = calculate_ballistic_velocity(bullet_instance.global_position, target_position, GRAVITY)
		bullet_instance.linear_velocity = ballistic_velocity

	print("Bullet disparado: origen=", bullet_instance.global_position, " objetivo=", target_position)
