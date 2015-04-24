include <configuration.scad>;

use <frame_motor.scad>;
use <frame_top.scad>;
use <endstop.scad>;
use <glass_tab.scad>;

% translate([0, 0, -3]) color("white") cylinder(r=85, h=3);
union() {
  translate([-15, -55, 22.5]) frame_motor();
  translate([15, 55, 7.5]) rotate([0, 0, 180]) frame_top();
  translate([-40, 30, 0]) rotate([0, 0, -30]) import("carriage_fixed.stl", convexity=10);

  translate([0, 0, 7.5]) endstop();
  translate([45, -30, 0]) rotate([0, 0, 150]) import("vertical_carriage_base.stl"); //glass_tab();
  translate([55, 50, 0]) rotate([0, 0, 120]) import("VibrationDamper.stl");
//  translate([-55, -50, 0]) rotate([0, 0, -60]) import("VibrationDamper.stl");
  translate([61, 10, 0]) rotate([0, 0, -60]) import("VibrationDamper.stl");

 translate([-63, -23, thickness/2]) rotate([0, 0, -150]) glass_tab();
 // translate([-18, -30, 0]) rotate([0, 0, -60]) import("1cm-radius-m3-disks.stl");
 // translate([-25, 65, 0]) rotate([0, 0, -60]) import("1cm-radius-m3-disks.stl");

}
