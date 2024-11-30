extends Area2D

const SPEED = 40  # Normal random movement speed
const AGGRO_SPEED = 80  # Speed when aggroed to the player
const AGGRO_RANGE = 400  # Distance to trigger aggro towards player

const RANDOM_MOVE_INTERVAL = 2.0  # Time in seconds to pick a new random direction
const aggro_range = 100  # Adjust as necessary

var direction = Vector2.ZERO
var player = null
var last_move_change = 0.0
signal check_consumption

@onready var ray_casts = [$RayCastRight, $RayCastLeft, $RayCastDownLeft, $RayCastUpLeft, $RayCastDownRight, $RayCastUpRight]

func _ready():
	# Find the player node in the scene tree (you can adjust the path or assign player dynamically)
	player = get_node("/root/Game/Player")  # Replace "Player" with the correct path if necessary

func _process(delta):
	#print("not found the player!")
	if player:
		#print("found the player!")
		# Check the distance to the player
		var distance_to_player = position.distance_to(player.position)
		
		# If within aggro range, chase the player
		if distance_to_player < AGGRO_RANGE:
			direction = (player.position - position).normalized()
			move(delta, AGGRO_SPEED)
		else:
			# Random movement
			last_move_change += delta
			if last_move_change >= RANDOM_MOVE_INTERVAL:
				last_move_change = 0
				direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			move(delta, SPEED)
		if distance_to_player < aggro_range and scale.length() < player.scale.length():
			emit_signal("consumed")
			queue_free()  # Remove the enemy from the scene

#func _on_area_entered(area):
	#if area.name == "Player":  # Check if the colliding area is the player
		#emit_signal("check_consumption", self)  # Emit with self reference

func consume():
	queue_free()  # Remove the enemy from the scene when consumed

func move(delta, speed):
	# Obstacle avoidance
	for ray_cast in ray_casts:
		if ray_cast.is_colliding():
			direction += ray_cast.get_collision_normal()
			direction = direction.normalized()
	
	# Apply movement
	position += direction * speed * delta
