extends Camera2D

@export var background_color: Colors
@export var layout_width: float

const default_size: Vector2 = Vector2(320, 180)

enum Colors { white, day, sunset, night }

var _background_colors: Dictionary = {
	Colors.white: "ffffff", 
	Colors.day: "aad9ff", 
	Colors.sunset: "f77758", 
	Colors.night: "0C001f",
}

@onready var background: Polygon2D = $"pol_background"
@onready var debug_screen: Sprite2D = $"spr2D_reference"
@onready var fade_screen: Polygon2D = $"pol_fade"
@onready var fade_player: AnimationPlayer = $"anipl_fade"
@onready var mouse_cursor: AnimatedSprite2D = $"anisprite_cursor"

func _ready() -> void:
	background.color = Color(_background_colors[background_color])
	debug_screen.visible = false
	
	var zoom_amout: float = 1920 / default_size.x
	if layout_width:
		zoom_amout = 1920 / layout_width
	zoom = Vector2( zoom_amout, zoom_amout )
	
	fade_screen.visible = true
	fade_player.play("fade_in")

func _process(delta: float) -> void:
	pass

func _onButtonQuitPressed() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_cursor.global_position = event.global_position / zoom
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_cursor.play("click")
			else:
				mouse_cursor.play("normal")
		
