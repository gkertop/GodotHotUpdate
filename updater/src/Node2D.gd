extends Node2D


onready var label = $Label2
onready var sprite = $Sprite2


func _ready():
	label.text = "script new2"
	sprite.texture  = load("res://src/b.png")

