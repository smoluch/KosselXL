/**************
SteExtruder by SteDf

Based on Johann's Kossel extruder from the repo files at
https://github.com/jcrocholl/kossel

which is Based on "Makergear Filament drive goes Bowden" by Luke321
http://www.thingiverse.com/thing:63674
**************/

include <configuration.scad>;

/**************
	ori_rad 	is the original radius of the pulley / spur gear
				it's the base for all the calculations, 
				so do not modify it !!!

	new_rad 	is the radius of the pulley / spur gear

	pn_rad 	is the radius of the pneumatic fit screw

	pi_rad 		is the extra radius for the pulley / spur gear indent

	pi_h 		is the height of the pulley / spur gear indent

	hmount	is to enable (1) or disable (0) the mounting bracket

	to obtain the same dimensions as per the original Johann's design just modify:
	new_rad = 6.6;
	pi_rad = 0.4;
	pi_h = 5.6;
	pn_rad = 2.3;
	hmount = 0;
**************/

ori_rad = 6.6;		// do not modify everything is based on this


// ************ Parameters
new_rad = 6.4;

pi_h=5.6; 			// original was 5.6
pi_rad = 0.6; 		// original was 0.4

pn_rad = 2.3;		// original was 2.3

hmount = 1;
//Smoluch
mount_width = 15;
// ************ End Parameters

$fn=50;
m3_radius = 1.8;

gear_r = 12.5/2; //gear radius
gear_gr_r = 11/2; //gear groove radius
gear_h = 11;
gear_offset = 3; //groove offest from top
gear_id=8; //inner diameter

filament_offset = 22.5 ;//+ (new_rad - ori_rad);

module oring(dia, fi) {
	rotate_extrude(convexity = 10, $fn = 50)
	translate([dia/2+fi/2, 0, 0])
	circle(r = fi/2, $fn = 50);
}

module gear() {
    difference () {
        cylinder (r=gear_r, h = gear_h);
        translate ([0,0,gear_h-gear_offset]) oring (gear_gr_r*2,3);
        cylinder (d=gear_id, h = gear_h);
    }
}


    

module extruder() {
  rotate([90, 0, 0]) difference() {
    union() {
      // ----- main cylinder
      translate([16,20,21]) rotate([90,0,0]) cylinder(h=20, r=17.5, $fn=200);

      // ----- bearing mount /625 bearing
	translate([31 + (new_rad - ori_rad),20,21]) rotate([90,0,0]) cylinder (h=20, r=8, $fn=100);

      // ----- pushfit/pneufit mount
      translate([filament_offset, 6.5, 13])
        cylinder(r=7.5, h=20, center=true, $fn=6);

      // ----- filament support
      translate([21.75,6.5,34]) rotate([0,0,0]) cylinder (h=8, r=3);

      // ----- clamp
      translate([20, 0, 28]) cube([13, 20, 14]);
    }

    // ----- pulley opening
    translate([16,21,21]) rotate([90,0,0]){
      cylinder (h=22, r=new_rad+1);
      translate ([0,0,6.5])
        % color("blue")gear();

      rotate([0,0,45]) {
        //translate([14,0,0]) cylinder(h=22, r=1.6, $fn=12);
        translate([0,14,0]) cylinder(h=22, r=m3_radius);
        translate([-14,0,0]) cylinder(h=22, r=m3_radius);
        translate([0,-14,0]) cylinder(h=22, r=m3_radius);
      }
    }

    // ----- gearhead indentation
    translate([16,21,21]) rotate([90,0,0]) cylinder (h=3.35, r=11.25);

    // ----- pulley hub indentation
    translate([16,20-2,21]) rotate([90,0,0]) cylinder (h=pi_h, r=new_rad+pi_rad);

    // ----- bearing screws
    translate([31 + (new_rad - ori_rad),21,21]) rotate([90,0,0]) cylinder (h=22, r=2.6+0.15);
    #translate([31 + (new_rad - ori_rad),22,21]) rotate([90,30,0]) cylinder (h=8.01, r=4.7, $fn=6);

    // ----- bearing
    difference() {
      union() {
        translate([31,9.5,21]) rotate([90,0,0]) cylinder (h=5.25+0.75, r=8.5+0.5, $fn=100);
          //visualisation bearing
          %color("blue", 0.5) translate([31+(new_rad - ori_rad),9,21]) rotate([90,0,0]) cylinder (h=5, r=8, $fn=100);
        translate([31,9.5-5.25,21-8.25-2]) cube([20, 5.25, 18.5]);
        // ----- opening between bearing and pulley
        translate([20,9.5-5.25,21-8.25+3.25+1]) cube([10, 5.25, 8]);
      }
//washers
        translate([31 + (new_rad - ori_rad),4.1,21]) rotate([90,0,0]) cylinder (h=0.6, r=7/2);
        translate([31 + (new_rad - ori_rad),9.5,21]) rotate([90,0,0]) cylinder (h=0.6, r=7/2);

      // ----- removable supports
      for (z = [15:3:27]) {
       // translate([36, 10, z]) # cube([20, 20, 0.5], center=true);
      }
    }

    // ----- filament path chamfer
    translate([filament_offset,6.5,12]) rotate([0,0,0]) #
      cylinder(h=6, r1=0.5, r2=3);

    // ----- filament path
    translate([filament_offset,6.5,-10]) rotate([0,0,0]) 
      cylinder(h=60, r=1.1); //1.1
    color("red",0.5) % translate([filament_offset,6.5,-10]) rotate([0,0,0]) 
      cylinder(h=60, r=1.75/2); //1.1

    // ----- pushfit/pneufit mount
    translate([filament_offset, 6.5, 0]) # cylinder(r=pn_rad, h=8);

    // ----- clamp slit
    color ("orange") translate([25 + (new_rad - ori_rad),-1,10]) cube([2, 22, 35]);
    // ----- clamp nut
    translate([10.5,12,38]) rotate([0,90,0])
      cylinder(h=11, r=m3_nut_radius, $fn=6);
    // ----- clamp screw hole
    translate([15,12,38]) rotate([0,90,0])
      cylinder(h=20, r=m3_wide_radius);
  }

  // ----- with mounting bracket	
  if (hmount) {
	difference() {
  	hull () {translate([2,-42.5,0]) rotate([0,0,90]) cube([42,4,mount_width ]);
	    translate([-2,-51.5,0]) rotate([0,0,90]) cube([60,4,mount_width ]);
    }
     
	      translate([-6,-51.5+5,mount_width /2]) rotate([0,90,0]) cylinder(h=10, r=m3_wide_radius);
    translate([-2,-51.5+5,mount_width /2]) rotate([0,90,0]) cylinder(h=10, d=m3_nut_od);
          translate([-6,0+4,mount_width /2]) rotate([0,90,0]) cylinder(h=10, r=m3_wide_radius);
          translate([-2,0+4,mount_width /2]) rotate([0,90,0]) cylinder(h=10, d=m3_nut_od);
    }

 }
}

module m3_knob() {
   
    difference () {
    hull()
 {   
        cylinder (d=20 , h=4, $fn=100);
    translate ([0,0,4]) cylinder (d=7,h=5, $fn=100);
}
        for (i=[1:10]) {
            rotate ([0,0,i*36]) translate ([12,0,0]) cylinder (d=6, h=6);
        }
    }
   /* difference () {
        translate ([0,0,6]) cylinder (d=15, h=5, $fn=100);
        translate ([0,0,6+2.5]) oring(7.5,5);
    }*/
    
}


extruder();
//m3_knob();
