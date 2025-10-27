shader_type canvas_item;
uniform vec4 tint_color : source_color = vec4(1.0, 0.5, 0.5, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV) * tint_color;
}
