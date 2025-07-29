shader_type canvas_item;

uniform vec4 display_color : hint_color;

uniform vec4 ignored_color_1 : hint_color;
uniform vec4 ignored_color_2 : hint_color;
uniform vec4 ignored_color_3 : hint_color;
uniform vec4 ignored_color_4 : hint_color;
uniform vec4 ignored_color_5 : hint_color;
uniform vec4 ignored_color_6 : hint_color;
uniform vec4 ignored_color_7 : hint_color;
uniform vec4 ignored_color_8 : hint_color;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	if (tex_color.a > 0.0) {
		if (distance(tex_color.rgb, ignored_color_1.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_2.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_3.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_4.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_5.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_6.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_7.rgb) < 0.01 ||
			distance(tex_color.rgb, ignored_color_8.rgb) < 0.01) {
			discard;
		}
		COLOR = display_color;
	} else {
		discard;
	}
}