shader_type canvas_item;

uniform float percent : hint_range(0, 1);

float bound(float mid_uv, float screen_size, int dir) {
	return (mid_uv + ((mid_uv * percent) * float(dir))) / screen_size;
}
// dir = -1 or 1
vec2 boundary(vec2 mid, vec2 screen, int dir) {
	return vec2(bound(mid.x, screen.x, dir), bound(mid.y, screen.y, dir));
}

void fragment() {
	vec2 screen = vec2(640.0, 480.0);
	vec2 mid = vec2(screen.x / 2.0, screen.y / 2.0);
	//mat2 box = mat2(boundary(mid, SCREEN_UV, -1), boundary(mid, SCREEN_UV, 1));
	mat2 box = mat2(vec2(mid.x - (mid.x * percent), mid.y - (mid.y * percent)), vec2(mid.x + (mid.x * percent), mid.y + (mid.y * percent)));
	box[0].x = box[0].x / screen.x;
	box[0].y = box[0].y / screen.y;
	box[1].x = box[1].x / screen.x;
	box[1].y = box[1].y / screen.y;
	
	if (UV.x > box[0].x && UV.y > box[0].y && UV.x < box[1].x && UV.y < box[1].y) {
		COLOR = vec4(0.0);
	} else {
		COLOR = texture(TEXTURE, UV);
	}
	
}