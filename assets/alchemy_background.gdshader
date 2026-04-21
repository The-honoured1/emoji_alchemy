shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.05, 0.05, 0.15, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.1, 0.02, 0.1, 1.0);
uniform float speed : hint_range(0.0, 2.0) = 0.5;

void fragment() {
	vec2 uv = UV;
	float time = TIME * speed;
	
	// Create some movement
	uv.x += sin(uv.y * 5.0 + time) * 0.02;
	uv.y += cos(uv.x * 5.0 + time * 0.8) * 0.02;
	
	float mix_value = uv.y + sin(uv.x * 3.0 + time) * 0.1;
	vec4 final_color = mix(color_top, color_bottom, clamp(mix_value, 0.0, 1.0));
	
	// Add subtle "stars" or magic dust
	float noise = fract(sin(dot(UV + time * 0.01, vec2(12.9898, 78.233))) * 43758.5453);
	if (noise > 0.998) {
		final_color += vec4(0.2, 0.2, 0.5, 0.0) * (sin(time * 2.0 + noise * 10.0) * 0.5 + 0.5);
	}
	
	COLOR = final_color;
}
