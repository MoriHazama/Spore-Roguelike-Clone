extends CharacterBody2D


#const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0#ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 400  # speed in pixels/sec
var scale_increment = 0.1  # Adjust to control growth rate


func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	

func _ready():
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.connect("collected", Callable(self, "_on_coin_collected"))
	# Connect to the "check_consumption" signal for each enemy in the scene
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.connect("consumed", Callable(self, "_on_enemy_consumed"))

func _on_coin_collected():
	self.scale += Vector2(scale_increment, scale_increment)
	#print("scale incremented")
	
func _on_enemy_consumed():
	self.scale += Vector2(scale_increment, scale_increment)
	print("Enemy consumed: scale incremented")

#func _on_check_consumption(enemy):
#	print(enemy.global_scale.length())
#	# Check if the enemy's scale is smaller than the player's scale
#	if enemy.global_scale.length() < global_scale.length():
#		enemy.consume()  # Call the consume function on the enemy
#		self.scale += Vector2(scale_increment, scale_increment)
#		print("Enemy consumed: player scale incremented")
	
#extends CollisionShape2D
#
#var speed = 400  # speed in pixels/sec
#
#func _physics_process(delta):
	#var direction = Input.get_vector("left", "right", "up", "down")
	#velocity = direction * speed
#
	#move_and_slide()
#
