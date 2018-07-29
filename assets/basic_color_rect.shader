shader_type canvas_item;
render_mode blend_add;

void fragment()
{
	COLOR = vec4(0.0,0.0,0.0,1.0);
	COLOR += 0.05 * abs(cos(TIME*4.0));
}