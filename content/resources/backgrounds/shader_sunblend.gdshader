shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec4 phoenix_blend(vec4 base, vec4 blend) {
    return min(base, blend) - max(base, blend) + 1.0;
}

void fragment() {
    vec4 base = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec4 blend = texture(TEXTURE, UV);

    if (blend.a > 0.0) {
        vec4 blended = phoenix_blend(base, blend);
        COLOR = vec4(blended.rgb, blend.a); // preserve sprite’s alpha
    } else {
        COLOR = base;
    }
}
