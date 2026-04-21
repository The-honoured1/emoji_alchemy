shader_type canvas_item;

uniform vec4 color_bg : source_color = vec4(0.02, 0.02, 0.05, 1.0);
uniform vec4 color_accent : source_color = vec4(0.1, 0.1, 0.2, 1.0);
uniform float speed : hint_range(0.0, 2.0) = 0.5;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	// Quantize UVs for pixelated look (though viewport resolution handles most of it)
	vec2 pixel_uv = floor(UV * vec2(180.0, 320.0)) / vec2(180.0, 320.0);
	float time = TIME * speed;
	
	vec4 color = color_bg;
	
	// Dithered gradient effect
	float dither = random(pixel_uv);
	if (pixel_uv.y + sin(pixel_uv.x * 5.0 + time * 0.2) * 0.1 > dither * 1.5) {
		color = mix(color_bg, color_accent, 0.3);
	}
	
	// Static pixel stars
	if (random(pixel_uv + floor(time * 0.1)) > 0.995) {
		color += vec4(0.4, 0.4, 0.6, 0.0);
	}
	
	COLOR = color;
}
