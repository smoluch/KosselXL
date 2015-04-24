hole_spacing = 19.5/2;
axle_h = 19.5;
axle_d= 8;
gearbox_groove_d = 22;
gearbox_d = 36;

base_plate_h = 5;
m3_radius = 1.8;
m3_nut_radius = 3.4;
m3_nut_height = 3;

spur_d = 12;
spur_offset = 2;
spur_h=16;
spur_groove_offset = 5; //from top

hole_offset = [
[hole_spacing, hole_spacing, 0],
[-hole_spacing, hole_spacing, 0],
[hole_spacing, -hole_spacing, 0],
[-hole_spacing, -hole_spacing, 0]];

bearing_id=5;
bearing_od=16;
bearing_h=5;

filament_d=1.75;
teeth_g = 0.5;

off = 5;

module base_plate() {
	difference () {
        union () {
            cylinder (d=gearbox_d, h=base_plate_h);
            translate ([-gearbox_d/2,0,0]) cube ([gearbox_d, gearbox_d, base_plate_h]);
        }
        for (a = hole_offset) {
            translate (a)
                cylinder (r=m3_radius, h=base_plate_h, $fn = 20);
        }
    cylinder (d=spur_d+spur_offset, h=base_plate_h, $fn = 20);
    cylinder (d=gearbox_groove_d, h=2, $fn = 20);
	}
    
    //spur gear
    %cylinder (d=spur_d, h=spur_h, $fn = 20);    
    //filament
    %color ("red") translate ([0,-spur_d/2-filament_d/2+teeth_g,spur_h-spur_groove_offset]) rotate ([0,90,0]) cylinder (d=filament_d, h=gearbox_d*1.2, $fn=20, center = true);
    %translate ([0,-spur_d/2-bearing_od/2-filament_d+teeth_g,spur_h-spur_groove_offset-2.5]) bearing_625();
}

module base_plate_2() {
	difference () {
        union () {
            linear_extrude (height = base_plate_h) offset (r=off) square (gearbox_d-2*off, center = true);
            translate ([-gearbox_d/2,0,0]) cube ([gearbox_d, gearbox_d, base_plate_h]);
        }
        for (a = hole_offset) {
            translate (a)
                cylinder (r=m3_radius, h=base_plate_h, $fn = 20);
        }
    cylinder (d=spur_d+spur_offset, h=base_plate_h, $fn = 20);
    cylinder (d=gearbox_groove_d, h=2, $fn = 20);
	}
    
    //spur gear
    %cylinder (d=spur_d, h=spur_h, $fn = 20);    
    //filament
    %color ("red") translate ([0,-spur_d/2-filament_d/2+teeth_g,spur_h-spur_groove_offset]) rotate ([0,90,0]) cylinder (d=filament_d, h=gearbox_d*1.2, $fn=20, center = true);
    %translate ([0,-spur_d/2-bearing_od/2-filament_d+teeth_g,spur_h-spur_groove_offset-2.5]) bearing_625();
}

module arm() {
        %    translate ([0,0,base_plate_h]) 
    intersection () {
        difference () {
            cylinder (d=gearbox_d, h=spur_h-base_plate_h);    
            cylinder (d=bearing_od/2-(-spur_d/2-bearing_od/2-   filament_d+teeth_g), h=spur_h-base_plate_h);    
            translate (hole_offset[3]) cylinder (r=m3_radius,h=spur_h, $fn=32);
        }
            translate ([-gearbox_d/2,-gearbox_d/2,0]) cube ([gearbox_d, gearbox_d/2, spur_h-base_plate_h]);
        
    }
}
base_plate_2();
//arm();


module bearing_625() {
    $fn=32;
    difference() {
        cylinder (d=16, h=5);
        cylinder (d=5, h=5);
    }
}

module frame_mount() {
    
}