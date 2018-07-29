shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0,1.0);
uniform sampler2D filter : hint_albedo;

void fragment()
{
	/*COLOR = texture(SCREEN_TEXTURE,SCREEN_UV);
	vec4 tex = texture(filter, SCREEN_UV);
	if (tex.r < cutoff || cutoff > 0.999)
	{
		COLOR.rgb = vec3(0.0);
	}*/
	
	COLOR = vec4(0.0);
	vec4 tex = texture(filter, SCREEN_UV);
	if (tex.r < cutoff || cutoff > 0.999)
	{
		COLOR.a = 1.0;
	}
	
	/*float value = texture(filter,SCREEN_UV).r;
	COLOR = vec4(0.0,0.0,0.0,clamp((cutoff+0.1 - value) / 0.1,0.0,1.0));*/
	
	/*float value = texture(filter, SCREEN_UV).r;
	if (value < cutoff) {
		COLOR = vec4(0.0,0.0,0.0,1.0);
	} else if(value < cutoff +0.1) {
		COLOR = vec4(0.0,0.0,0.0,(cutoff + 0.1 - value) / 0.1);
	} else {
		COLOR = vec4(0.0,0.0,0.0,0.0);
	}*/
}