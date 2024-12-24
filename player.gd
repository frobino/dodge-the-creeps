extends Area2D
# Signal to emit when the player is hit by enemies
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the player at the beginning of the game
	hide()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1
	if (Input.is_action_pressed("move_up")):
		velocity.y -= 1
	if (Input.is_action_pressed("move_down")):
		velocity.y += 1

	# Decide which animation to play
	if (velocity.x != 0):
		get_node("AnimatedSprite2D").animation = "walk"
		get_node("AnimatedSprite2D").flip_v = false
		get_node("AnimatedSprite2D").flip_h = velocity.x < 0
	if (velocity.y != 0):
		get_node("AnimatedSprite2D").animation = "up"
		get_node("AnimatedSprite2D").flip_v = velocity.y > 0
	# Decide when to play animation
	if (velocity.length() > 0):
		velocity = velocity.normalized() * speed
		get_node("AnimatedSprite2D").play()
	else:
		get_node("AnimatedSprite2D").stop()

	# Update player position
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

# Signal emitted by the player when it hits a enemy
func _on_body_entered(body: Node2D) -> void:
	hide()
	# Emit hit signal to indicate that the player hit a enemy
	hit.emit()
	# Disable the player's collision so that we don't trigger the hit signal more than once.
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

# Used to restart the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
