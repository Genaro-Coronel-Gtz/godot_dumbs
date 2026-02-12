extends RigidBody3D

const BULLET_LIFE_TIME = 5.0
const FLIGHT_TIME_PARABOLIC = 1.5  # Tiempo de vuelo para una trayectoria más precisa
const BULLET_SPEED = 25 # Velocidad de la bala en trayectoria lineal
var time_alive = 0.0

func reset() -> void:
	"""Reinicia el bullet para ser reutilizado en el pool"""
	time_alive = 0.0
	linear_velocity = Vector3.ZERO
	global_position = Vector3.ZERO

func fire(target: Vector3) -> void:
	"""Dispara el bullet automáticamente según su tipo"""
	if name == "BulletBlue":
		# Si es bullet azul, disparo parabólico
		parabolic(target)
	else:
		# Si es bullet normal, disparo lineal
		linear(target)

func linear(target: Vector3) -> void:
	var Ballistics = load("res://scripts/ballistics.gd")
	var v = Ballistics.solve_direct_velocity(global_position, target, BULLET_SPEED)
	linear_velocity = v
	
# Lanzar el bullet hacia `target` en `flight_time` segundos.
func parabolic(target: Vector3) -> void:
	var gravity = abs(ProjectSettings.get_setting("physics/3d/default_gravity"))
	var Ballistics = load("res://scripts/ballistics.gd")
	var v = Ballistics.solve_ballistic_velocity(global_position, target, gravity, FLIGHT_TIME_PARABOLIC)
	linear_velocity = v

func _physics_process(delta):
	time_alive += delta
	if time_alive >= BULLET_LIFE_TIME:
		BulletPool.return_bullet(self)
		#queue_free()
