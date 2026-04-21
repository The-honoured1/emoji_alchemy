shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float pixel_size : hint_range(1.0, 64.0) = 16.0;

void fragment() {
	vec2 uv = UV;
	
	// Pixelate UV
	vec2 grid = floor(uv * (1.0 / TEXTURE_PIXEL_SIZE) / pixel_size);
	float val = fract(sin(dot(grid, vec2(12.9898, 78.233))) * 43758.5453);
	
	if (progress > val) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}
