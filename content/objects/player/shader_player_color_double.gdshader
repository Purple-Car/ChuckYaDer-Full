shader_type canvas_item;

uniform vec4 target_color_1 : source_color;
uniform vec4 new_color_1 : source_color;

uniform vec4 target_color_2 : source_color;
uniform vec4 new_color_2 : source_color;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    if (original_color == target_color_1) {
        COLOR = vec4(new_color_1.rgb, original_color.a);
    } else if (original_color == target_color_2) {
        COLOR = vec4(new_color_2.rgb, original_color.a);
    } else {
		COLOR = original_color;
	}
}

//void light() {
//}
