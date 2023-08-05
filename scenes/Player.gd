extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -280.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
@onready var dead_label = $DeadLabel


var alive = true
func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
			
	if alive:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if is_on_floor() && direction != 0:
			sprite.play('run')
		elif is_on_floor():
			sprite.play('default')
		elif !is_on_floor():
			sprite.play("jump")
			
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false

		move_and_slide()

func _on_spike_detector_body_entered(body):
	alive = false
	sprite.hide()
	dead_label.show()
