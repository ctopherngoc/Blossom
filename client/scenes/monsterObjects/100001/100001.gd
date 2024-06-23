extends KinematicBody2D

##########################################################
var monster_id = "100001"
var title = "Green Guy"
var floating_text = preload("res://scenes/userInerface/FloatingText.tscn")
var current_hp = null
var miss_counter = null
var max_hp = GameData.monsterTable[monster_id].maxHP
#var state = null
var xScale = 1.583
var despawn = 1
onready var timer = $Timer
onready var sprite = $Sprite
onready var label = $Label
onready var dmg_text_height = 10
############################################################

func _ready():
	pass

# new functions
func move(new_position):
	if despawn == 1:
		var curr_position = self.get_position()
		#turn right
		if new_position.x > curr_position.x:
			$Sprite.scale.x = xScale * -1
			animation_control('walk')
		#turn left
		elif new_position.x < curr_position.x:
			$Sprite.scale.x = xScale
			animation_control('walk')
		else:
			animation_control('idle')
		set_position(new_position)

#func health(health):
#	if health < current_hp:
#		var damage_took = str(current_hp - health)
#		print(str(self.name) + " took " + damage_took + " damage")
#		AudioControl.play_audio("squish")
#		var damage_text = floating_text.instance()
#		damage_text.type = "Damage"
#		damage_text.amount = damage_took
#		add_child(damage_text)
#		current_hp = health
#		health_bar_update()
		
#	elif health > current_hp:
#		var damage_heal = str(current_hp - health)
#		print(str(self.name) + " healed " + damage_heal + " health")
#		#AudioControl.play_audio("squish")
#		var heal_text = floating_text.instance()
#		heal_text.type = "Heal"
#		heal_text.amount = damage_heal
#		add_child(heal_text)
#	current_hp = health
#	health_bar_update()

#func damage_taken(health, damage_array: Array) -> void:
#	"""
#	change dammage_array to list of list
#	"""
#	if not damage_array.empty():
#		print("damage arr ", damage_array)
#		print("health: ", health)
#	current_hp = health
#	var damage_text = floating_text.instance()
#	damage_text.type = "Damage"
#	add_child(damage_text)
#	for damage in damage_array:
#		# damage[0]
#		print(str(self.name) + " took " + str(damage) + " damage")
#		#damage_text.amount = damage
#		# damage[0]
#		damage_text.label.text = ("%s\n" % str(damage)) + damage_text.label.text
#		#damage[0]
#		#current_hp -= damage
#		health_bar_update()
#		yield(get_tree().create_timer(0.2),"timeout")

func damage_taken(health, damage_array: Array) -> void:
	current_hp = health
	var lines = 0
	for damage in damage_array:
		var damage_text = floating_text.instance()
		damage_text.position.y = dmg_text_height
		damage_text.position.y -= 35 * lines
		damage_text.type = damage[1]
		damage_text.amount = damage[0]
		add_child(damage_text)
		lines += 1
		health_bar_update()
		yield(get_tree().create_timer(0.1),"timeout")

# health bar above monsters head on hit/death, not implemented yet
func health_bar_update():
	pass

func on_death():
	AudioControl.play_audio("deathSquish")
	$AnimationPlayer.play("die")
	despawn = 0
	get_node("do_damage/CollisionShape2D").set_deferred("disabled", true)
	get_node("take_damage/CollisionShape2D").set_deferred("disabled", true)
	label.visible = false
	sprite.modulate = Color8(62,62,62)
	timer.start()
	print("%s died" % self.name)
	yield(timer, "timeout")

func animation_control(animation):
	if animation == 'idle':
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("walk")


func _on_Timer_timeout():
	self.queue_free()
