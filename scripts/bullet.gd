extends RigidBody3D

const BULLET_LIFE_TIME = 5.0

var time_alive = 0.0

# Public API: lanzar el bullet hacia `target` en `flight_time` segundos.
func launch(target: Vector3, flight_time: float = 1.5) -> void:
	var gravity = abs(ProjectSettings.get_setting("physics/3d/default_gravity"))
	var Ballistics = load("res://scripts/ballistics.gd")
	var v = Ballistics.solve_ballistic_velocity(global_position, target, gravity, flight_time)
	linear_velocity = v

func _physics_process(delta):
	time_alive += delta
	if time_alive >= BULLET_LIFE_TIME:
		queue_free()
