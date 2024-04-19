class_name SnakePart extends Area2D

var last_postition: Vector2

func move_to(new_position: Vector2):
	last_postition = self.position
	self.position = new_position
