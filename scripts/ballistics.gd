# Utilidad de balística: calcula la velocidad inicial necesaria
# para que un proyectil salga de `from` y llegue a `to` en `flight_time` segundos

static func solve_ballistic_velocity(from: Vector3, to: Vector3, gravity: float, flight_time: float) -> Vector3:
	var diff = to - from
	if diff.length() < 0.001:
		return Vector3.ZERO
	# velocidad promedio necesaria
	var v = diff / flight_time
	# ajustar vy con la ecuación y = y0 + vy*t - 0.5*g*t^2
	var vy = (diff.y + 0.5 * gravity * flight_time * flight_time) / flight_time
	v.y = vy
	return v

# Calcula velocidad para un tiro directo (sin parábola) hacia el objetivo
static func solve_direct_velocity(from: Vector3, to: Vector3, speed: float) -> Vector3:
	var direction = (to - from).normalized()
	return direction * speed
