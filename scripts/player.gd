extends CharacterBody3D

const SPEED = 10.0

var camera: Camera3D

func _ready():
	camera = get_tree().root.get_node("Main/Camera3D")

func _physics_process(delta):
	# Movimiento con flechas del teclado
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector3.ZERO
	
	move_and_slide()
	
	# Actualizar posición de la cámara para seguir al player
	camera.global_position = global_position + Vector3(0, 3, 5)
	camera.look_at(global_position, Vector3.UP)
