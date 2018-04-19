extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var direction = {
	up 		= 0.0,
	right 	= 0.0
}

var screen_width
var screen_height

export var speed = 0
export var dodge_length = 0

var ability_dodge_cooldown = 0
export var ability_dodge_cooldown_time = 0
var ability_dodge_cooldown_bar

var draw_schut_line = false
export var draw_schut_line_time = .1
var draw_schut_line_time_current = 0

export var health_max = 2.0
var health
var health_bar

var laser

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	health = health_max
	health_bar = get_node("/root/scene/CanvasLayer/Health")
	laser = get_node("CollisionShape2D/Sprite/Laser")
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	
	ability_dodge_cooldown_bar = get_node("/root/scene/CanvasLayer/AbilityDodgeBar")

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	
	direction.up = 0.0
	direction.right = 0.0
	
	var next_position = global_transform.origin
	if Input.is_action_pressed("MoveLeft"):
		direction.right = -1.0
	if Input.is_action_pressed("MoveRight"):
		direction.right = 1.0
	if Input.is_action_pressed("MoveUp"):
		direction.up = 1.0
	if Input.is_action_pressed("MoveDown"):
		direction.up = -1.0
	
	if (direction.up != 0 or direction.right !=0) and AbilityDodgeCheck():
		next_position += Vector2(direction.right, -direction.up) * dodge_length
		ability_dodge_cooldown = ability_dodge_cooldown_time
	else:
		next_position += Vector2(direction.right, -direction.up) * speed * delta
	
	if next_position.x >= 0:
		if next_position.x <= screen_width:
			global_transform.origin.x = next_position.x
		else:
			global_transform.origin.x = screen_width
	else:
		global_transform.origin.x = 0
	if next_position.y >= 0:
		if next_position.y <= screen_height:
			global_transform.origin.y = next_position.y
		else: 
			global_transform.origin.y = screen_height
	else:
		global_transform.origin.y = 0
	
	if ability_dodge_cooldown >= 0:
		
		ability_dodge_cooldown -= 1.0 * delta
		ability_dodge_cooldown_bar.value = ability_dodge_cooldown / ability_dodge_cooldown_time * 100
	
	
	if draw_schut_line:
		laser.visible = true
		update()
	else:
		laser.visible = false
	draw_schut_line = false
	if Input.is_action_pressed("Fire"):
		Shoot(delta)
	
	var collisions = get_overlapping_areas()
	for collider in collisions:
		on_hit(delta)

func on_hit(delta):
	health -= delta
	health_bar.value = health / health_max * 100
	if health <= 0:
		get_tree().change_scene("res://landing.tscn")

func _draw():
	if draw_schut_line:
		var from = Vector2(5, -100)
		var to = Vector2(5, -screen_height)
		draw_line(from, to, Color(randf(), randf(), randf()), 5.0)

func Shoot(delta):
	var from = global_transform.origin
	var to = Vector2(global_transform.origin.x, 0)
	var space_state = get_world_2d().get_direct_space_state()
	
	draw_schut_line = true
	draw_schut_line_time_current = draw_schut_line_time
	
	var result = space_state.intersect_ray(from, to, [self])
	if not result.empty():
		print(result.collider.name)
		if "Enemy" in result.collider.name:
			result.collider.on_hit(1 * delta)

func AbilityDodgeCheck():
	return Input.is_action_just_pressed("Ability_Dodge") and ability_dodge_cooldown <= 0
