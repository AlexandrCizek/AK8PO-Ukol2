class_name Game extends Node2D

@onready var head: Head = %Head as Head
@onready var bounds = %Bounds as Bounds
@onready var spawner = $Spawner as Spawner

const gameover_scene: PackedScene = preload("res://game_over.tscn")
var gameover_menu: GameOver

var time_between_moves:float = 1000.0
var time_since_last_move:float = 0
var speed:float = 5000.0
var move_direction: Vector2 = Vector2.RIGHT
var snake_parts: Array[SnakePart] = []
var score: int = 0

func _ready():
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_collided_with_tail)
	spawner.tail_added.connect(_on_tail_added)
	spawner.spawn_food()
	snake_parts.push_back(head)

func _process(delta):
	if Input.is_action_pressed("move_up"):
		move_direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		move_direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		move_direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		move_direction = Vector2.RIGHT	

func _physics_process(delta):
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0

func update_snake():
	var new_position: Vector2 = head.position + move_direction * Global.GRID_SIZE
	
	new_position = bounds.wrap_vector(new_position)
	head.move_to(new_position)
	
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_postition)
	
func _on_food_eaten():
	spawner.call_deferred("spawn_food")
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size() - 1].last_postition)
	speed += 500.0
	score += 1
	
func _on_collided_with_tail():
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		gameover_menu.set_score(score)
	
func _on_tail_added(tail: Tail):
	snake_parts.push_back(tail)
