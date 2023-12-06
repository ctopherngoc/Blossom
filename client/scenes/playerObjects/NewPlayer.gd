extends KinematicBody2D

onready var velocity_multiplier = 1
# dynamic player variables
#onready var player = Global.player
onready var jump_speed
onready var max_horizontal_speed
onready var velocity = Vector2.ZERO
var attack_speed = 1.5

# static player varaibles
onready var horizontal_acceleration = 3
onready var gravity = 800

# player states
export var can_climb = false
export var is_climbing = false
#onready var direction = "RIGHT"
onready var attacking = false
onready var player_state

onready var sprite = $CompositeSprite/AnimationPlayer
onready var animation = {
	"f": 1,
	"d": 1
}

func _ready():
	$Label.text = Global.player.displayname
	max_horizontal_speed = (Global.player.stats.movementSpeed)
# warning-ignore:return_value_discarded
	Signals.connect("dialog_closed", self, "movable_switch")
	
	jump_speed = (Global.player.stats.jumpSpeed)

func _physics_process(delta):
	if Global.movable:
		movement_loop(delta)
	#define_player_state()

func define_player_state():
	# for client prediction
	# edit player state to send button press and not global position
	# client sprite will move -> send input -> server will recreate movement and return position
	# client will validate positioning the same or rubberband to server position
	# probably can remove animation for floor nnot on floor because server will calculate
	player_state = {"T": Server.client_clock, "P": get_input()}
	#player_state = {"T": Server.client_clock, "P": get_global_position(), "M": Global.current_map, "A": animation}
	Server.send_player_state(player_state)

	
func get_input():
	if Input.is_action_pressed("ui_up"):
		print("up ", velocity.y)
		return[1,0,0,0]
	elif Input.is_action_pressed("ui_left"):
		print("left ", velocity.x)
		return[0,1,0,0]
	elif Input.is_action_pressed("ui_down"):
		print("down ", velocity.y)
		return[0,0,1,0]
	elif Input.is_action_pressed("ui_right"):
		print("right ", velocity.x)
		return[0,0,0,1]
	else:
		return[0,0,0,0]

func movement_loop(delta):
	change_direction()
	var move_vector = get_movement_vector()
	
	# change get velocity
	get_velocity(move_vector, delta)
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)
	
	# can be determined by server?
	# player state if jumping
	"""
	if is_on_floor():
		animation["f"] = 1
	else:
		animation["f"] = 0
	"""
	
	if is_on_floor() or !is_climbing:
		velocity = move_and_slide(velocity, Vector2.UP)
	if is_climbing:
		velocity.x = 0

	update_animation()

func get_movement_vector():
	var moveVector = Vector2.ZERO
	
	# calculating x vector, allow x-axis jump off ropes or idle on floor
	if (!attacking && is_on_floor()) or (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) and Input.get_action_strength("jump"):
		moveVector.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * velocity_multiplier
	else:
		moveVector.x = 0	
	# calculating y vector, allow jump off ropes
	if is_climbing:
		if (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) and Input.get_action_strength("jump"):
			moveVector.y = -1
		else:
			moveVector.y = 0
	else:
		if Input.get_action_strength("jump") && !attacking:
			moveVector.y = -1
		else:
			moveVector.y = 0
	return moveVector

func get_velocity(move_vector, delta):
	"""
	fix this first so velocity is constant and not
	variable to maxspeed
	input -> client preidition -> send input to server -> server validates through mirror
	recieve server position -> server recon
	"""
	velocity.x += move_vector.x * max_horizontal_speed
	# slow down movement
	if(move_vector.x == 0):
		# allows forward jumping
		if(is_on_floor()):
			# instant stop
			velocity.x = 0
	
	# allows maximum velocity
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	if can_climb:
		if is_climbing:
			velocity.y = 0
			if Input.is_action_pressed("ui_up"):
				velocity.y = -100
			elif Input.is_action_pressed("ui_down"):
				velocity.y = 100
				if is_on_floor():
					is_climbing = false
			# jump off rope
			elif Input.is_action_pressed("jump") && (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
				is_climbing = false
				velocity.y = move_vector.y * jump_speed * .8
				velocity.x = move_vector.x * 200
		# can climb but not climbing
		else:
			#if moving
			if (move_vector.y < 0 && is_on_floor()):
					velocity.y = move_vector.y * jump_speed
			# press up on ladder initiates climbing
			elif (!is_on_floor() && Input.is_action_pressed("ui_up")) or (is_on_floor() && Input.is_action_pressed("ui_down")):
					is_climbing = true
					velocity.y = 0
					velocity.x = 0
			# over lapping ladder pressing nothing allows gravity
			else:
				velocity.y += gravity * delta
	# not climbable state
	else:
		# normal movement
		if (move_vector.y < 0 && is_on_floor()):
			velocity.y = move_vector.y * jump_speed
		else:
			velocity.y += gravity * delta
	if !can_climb:
		is_climbing = false
	#print (velocity.x)
# attack > jump > walking > takeDamage > standing
func update_animation():
	var move_vector = get_movement_vector()
	if(attacking):
		pass
	
	# send rpc to server
	elif(Input.is_action_pressed("attack") && !is_climbing && Global.movable):
		attacking = true
		sprite.play("slash",-1, attack_speed)
	else:
		if(!is_on_floor()):
			pass
			sprite.play("jump")

		elif(move_vector.x != 0):
			sprite.play("walk")
	#	elif(tookDamage):
	#		$AnimationPlayer.play("ready")
		else:
			sprite.play("idle")

func movable_switch():
	Global.movable = true
	
func flip_sprite(d):
	for _i in $CompositeSprite.get_children():
		if _i.name != "AnimationPlayer":
			if d:
				_i.set_flip_h(true)
			else:
				_i.set_flip_h(false)

func change_direction():
	if Input.is_action_pressed("move_right") && !attacking && !Input.is_action_pressed("move_left"):
		#direction = "RIGHT"
		if velocity.x < 0 && is_on_floor():
			velocity.x = 0
		flip_sprite(false)
		#animation["d"] = 1
	elif Input.is_action_pressed("move_left") && !attacking && !Input.is_action_pressed("move_right"):
		#direction = "LEFT"
		if velocity.x > 0 && is_on_floor():
			velocity.x  = 0
		flip_sprite(true)
		#animation["d"] = 0


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		if Global.movable:
			return
		else:
			print("cannot attack")

func overlappingBodies():
	print("area ovlapping: " + str($do_damage.get_overlapping_areas().size()))
	for body in $do_damage.get_overlapping_areas():
		print('player overlapping with: ', body)