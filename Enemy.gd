extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var health = 0.0
export var speed = 200

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var screen_height = get_viewport_rect().size.y
	global_translate(Vector2(0, speed * delta))
	if global_transform.origin.y >= screen_height:
		die()

func on_hit(damage):
	health -= damage
	if health <=0:
		die()

func die():
	queue_free()
