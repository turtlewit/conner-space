extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var enemies_node
var enemies

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	enemies_node = preload("res://Prefabs/enemies.tscn")
	Spawn()

func Spawn():
	enemies = enemies_node.instance()
	add_child(enemies)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if enemies.get_children().empty():
		enemies.queue_free()
		Spawn()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://landing.tscn")
