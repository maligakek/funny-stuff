extends CharacterBody2D

#Stats
var movement_speed : float = 150

var health : float = 100:
	set(value):
		health = max(value, 0)
		%Health.value = value
		
var max_health : float = 100:
	set(value):
		max_health = value
		%Health.max_value = value

var recovery : float = 0

var armor : float = 0

var might : float = 1.5

var area : float = 0

var magnet : float = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 50 + value
		
var growth : float = 1
#Physics_process
var nearest_enemy : CharacterBody2D

var nearest_enemy_distance : float = 150 + area

#XP
var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value

var total_XP : int = 0

var level : int = 1:
	set(value):
		level = value
		%Level.text = "Lvl " + str(value)
		%Options.show_option()
		
		if level >= 3:
			%XP.max_value = 200
		elif level >= 7:
			%XP.max_value = 300

#dash mechanic
var dash_speed = 500
var is_dashing = false
var can_dash = true
#dash mechanic

func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = 150 + area
		nearest_enemy = null

	velocity = Input.get_vector("left","right","up","down") * movement_speed
	move_and_collide(velocity * delta)
	check_XP()
	health += recovery * delta

	#dash mechanic
	if is_dashing:
		velocity = Input.get_vector("left","right","up","down") * dash_speed
		move_and_collide(velocity * delta)

	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		$Dash_time.start()
		$Dash_again_time.start()
	#dash mechanic

func take_damage(amount):
	health -= max(amount - armor, 0)
	print(amount)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func gain_XP(amount):
	XP += amount * growth
	total_XP += amount  * growth

func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1

#dash mechanic
#stop dash
func _on_dash_time_timeout() -> void:
	is_dashing = false

func _on_dash_again_time_timeout() -> void:
	can_dash = true
#dash mechanic


func _on_magnet_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)
