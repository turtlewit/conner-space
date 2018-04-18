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


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y

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
	
	print(AbilityDodgeCheck())
	if (direction.up != 0 or direction.right !=0) and AbilityDodgeCheck():
		next_position += Vector2(direction.right, -direction.up) * dodge_length
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
	

func AbilityDodgeCheck():
	return Input.is_action_just_pressed("Ability_Dodge") and ability_dodge_cooldown <= 0