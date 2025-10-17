shader_type canvas_item;

uniform vec4 target_color : source_color;
uniform vec4 new_color : source_color;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    if (original_color == target_color) {
        COLOR = vec4(new_color.rgb, original_color.a);
    } else {
        COLOR = original_color;
    }
}

//void light() {
//}
