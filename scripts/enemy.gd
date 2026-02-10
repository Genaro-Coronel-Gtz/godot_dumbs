extends Node3D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const FIRE_RATE = 1.0  # segundos entre disparos
const FLIGHT_TIME_PARABOLIC = 1.5  # Tiempo de vuelo para una trayectoria más precisa
const BULLET_SPEED = 25
const FIRE_RANGE = 15.0  # Distancia máxima para disparar

var time_since_last_shot = 0.0
var player: Node3D

func _ready():
	player = get_tree().root.get_node("Main/Player")

func _physics_process(delta):
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		# Solo disparar si el player está dentro del rango
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
	#bullet_instance.parabolic(target_position, FLIGHT_TIME_PARABOLIC)
	bullet_instance.linear(target_position, BULLET_SPEED)

	print("Bullet disparado: origen=", bullet_instance.global_position, " objetivo=", target_position)
