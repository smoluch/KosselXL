include <configuration.scad>;

sticky_width = 25.4;
sticky_length = 15.4;
sticky_offset = 2;  // Distance from screw center to glass edge.
chink_length = 7;

// Make the round edge line up with the outside of OpenBeam.
screw_offset = sticky_width/2 - 7.5;
cube_length = sticky_length + sticky_offset - screw_offset;

module glass_tab() {
  difference() {
    translate([0, screw_offset, 0]) union() {
      cylinder(r=sticky_width/2, h=thickness, center=true);
      translate([0, cube_length/2, 0])
        cube([sticky_width, cube_length, thickness], center=true);
    }
	hull () {
		translate ([0,0,-thickness/2]) cylinder(r=m3_wide_radius, h=thickness, center=true, $fn=12);
		translate ([0,chink_length,-thickness/2]) cylinder(r=m3_wide_radius, h=thickness, center=true, $fn=12);
	}
	hull () {
		translate ([0,0,thickness/2+1]) cylinder(d=5.8, h=thickness+2, center=true, $fn=12);
		translate ([0,chink_length,thickness/2+1]) cylinder(d=5.8, h=thickness+2, center=true, $fn=12);
	}

	 translate([0, 170/2+5+chink_length, -thickness/2]) cylinder (d1=172, d2=170, h=thickness+1, $fn=100);
  }
  // Scotch restickable tab for mounting.
  translate([0, sticky_length/2+sticky_offset, thickness/2]) %
    cube([sticky_width, sticky_length, 0.7], center=true);
  // Horizontal OpenBeam.
  translate([0, 0, (15+thickness)/-2]) %
    cube([100, 15, 15], center=true);
}

module glass_tab_bolt() {
  difference() {
		union () {
			translate ([0,6,thickness/2]) cube ([9, 12, thickness], center = true);
			cylinder(r=3+1.5, h=thickness*2, center=true, $fn=12);
		}	
	cylinder(r=m3_wide_radius, h=thickness*2+1, center=true, $fn=12);
	translate ([0,0,thickness]) cylinder(r=3, h=thickness*2+1, center=true, $fn=12);
	}
 }

translate([0, 0, thickness/2]) glass_tab();
//translate([20, 0, thickness]) rotate([180,0,180]) glass_tab_bolt();