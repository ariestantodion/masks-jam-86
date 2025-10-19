shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    float radius = 0.5; // full circle inside a square rect

    float dist = distance(uv, center);

    if (dist > radius) {
        discard;
    }

    // Use the node's modulate color (ColorRect/TextureRect)
    COLOR = texture(TEXTURE, UV) * COLOR;
}