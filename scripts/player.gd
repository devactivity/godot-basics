extends CharacterBody2D

const SPEED = 100
var health = 100

var player_stat
var current_direction = "none"
var enemy_in_range = false
var attack_cooldown = true
var player_alive = true
var attack_progress = false

func _ready():
	$AnimatedSprite2D.play("idle-front")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_health()
		
	if health <= 0:
		player_alive = false # add end screen (respawn, go back to menu, etc.)
		health = 0
		print('player has been killed')
		self.queue_free()
	
func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_direction = "on-right"
		play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_direction = "on-left"
		play_animation(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_direction = "on-down"
		play_animation(1)
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		current_direction = "on-up"
		play_animation(1)
		velocity.y = -SPEED
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_animation(movement):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
	if dir == "on-right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walking-side")
		elif movement == 0:
			if attack_progress == false:
				anim.play("idle-side")
				
	if dir == "on-left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walking-side")
		elif movement == 0:
			if attack_progress == false:
				anim.play("idle-side")
				
	if dir == "on-down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walking-front")
		elif movement == 0:
			if attack_progress == false:
				anim.play("idle-front")
	if dir == "on-up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walking-back")
		elif movement == 0:
			if attack_progress == false:
				anim.play("idle-back")

func player():
	pass
	
func _on_attacking_zone_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true

func _on_attacking_zone_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range = false
		
func enemy_attack():
	if enemy_in_range and attack_cooldown:
		health -= 10
		attack_cooldown = false
		
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	attack_cooldown = true
	
func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack_button"):
		Global.player_current_attack = true
		attack_progress = true
		
		if dir == "on-right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack-side")
			$deal_attack_timer.start()
		if dir == "on-left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack-side")
			$deal_attack_timer.start()
		if dir == "on-down":
			$AnimatedSprite2D.play("attack-front")
			$deal_attack_timer.start()
		if dir == "on-up":
			$AnimatedSprite2D.play("attack-back")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_progress = false

func current_camera():
	if Global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif Global.current_scene == "cliff_size":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_timer_timeout() -> void:
	if health < 100:
		health = health + 20
		
		if health > 100:
			health = 100
	
	if health <= 0:
		health = 0
