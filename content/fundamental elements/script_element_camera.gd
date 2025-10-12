extends Camera2D

@export var background_color: Colors
@export var scale_multiplier: float
@export var background_element: Node2D

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
@onready var mouse_cursor: AnimatedSprite2D = $"canlay_nozoom/anisprite_cursor"

func _ready() -> void:
	if !background_element:
		assert(false, "Someone forgot to insert a background element")
	
	background.color = Color(_background_colors[background_color])
	debug_screen.hide()
	mouse_cursor.hide()
	
	rescaleCamera()
	
	fade_screen.show()
	Gamestate.call_fade.connect(doFade)
	Gamestate.changeState(Gamestate.States.fadein)

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	debugRescaleCamera(event)

	if event is InputEventMouseMotion:
		mouse_cursor.show()
		mouse_cursor.global_position = event.global_position / 6
	elif event is InputEventMouseButton:
		mouse_cursor.show()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_cursor.play("click")
			else:
				mouse_cursor.play("normal")
	elif event is InputEventKey and event.pressed and not event.echo:
		mouse_cursor.hide()

func _onAnimationFinished(anim_name: StringName) -> void:
	Gamestate.fadeFinished(anim_name)

func doFade(fade: String) -> void:
	fade_player.play(fade)

func rescaleCamera() -> void:
	var zoom_amount: float = 6 - scale_multiplier
	zoom = Vector2( zoom_amount, zoom_amount )

func debugRescaleCamera(event: InputEvent) -> void:
	if event.is_action_pressed("mscroll_up"):
			scale_multiplier = min(scale_multiplier + 1, 5)
			rescaleCamera()
	elif event.is_action_pressed("mscroll_down"):
			scale_multiplier = max(scale_multiplier - 1, 0)
			rescaleCamera()
