cylinder_thickness = 0.5;
flange_height = 1;
flange_width = 0.8;
diameter = 10.2;
bearing_width = 4;
bearing_diameter = 10;
margin = 0.2;
roller_diameter_big = 21;
roller_diameter_small = 15;
roller_width_big = 1.5;
roller_width_small = 4.25;
axis_diameter = 8;


$fn=100;
rounded = false;

module oring(dia, fi) {
	rotate_extrude(convexity = 10)
	translate([dia/2+fi/2, 0, 0])
	circle(r = fi/2);
}

module flansza() {
difference () {
	union() {
		cylinder (d=diameter + 2*flange_height + 2*cylinder_thickness, h=flange_width);
		if (rounded) {
			translate ([0,0,bearing_width-cylinder_thickness])oring(diameter, cylinder_thickness);
			cylinder (d=diameter + 2*cylinder_thickness, h=bearing_width-cylinder_thickness);
		}
		else {
			cylinder (d=diameter + 2*cylinder_thickness, h=bearing_width);
		}
	}
	cylinder (d=diameter, h= bearing_width);
}
}





for (i = [0:17]) {
	rotate ([0,0,360/18*i]) translate ([0,45,0]) flansza();
}
//translate ([0,0,2*bearing_width]) mirror ([0,0,1]) half();

module sroller() {
	difference () {
		union () {
			cylinder (d=roller_diameter_big, h= roller_width_big);
			translate ([0,0,roller_width_big]) cylinder (d=roller_diameter_small, h= roller_width_small);
		}
		cylinder (d=axis_diameter, h=roller_width_big+roller_width_small);
		translate ([0,0,roller_width_big+roller_width_small - bearing_width]) cylinder (d=bearing_diameter+margin, h=bearing_width);
	}
}

//sroller();