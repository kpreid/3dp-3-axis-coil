diameter = 40;
slot_width = 3;
slot_depth = 3;
sphere_resolution = 120;
handle_hole_diameter = 10;

epsilon = 0.01;
bigger = 100;
corner_angle = asin(1/sqrt(3));


half();


module half() {
    difference() {
        rotate([0, corner_angle, 0])
        rotate([45, 0, 0])
        coil_sphere();

        // remove symmetric bottom half
        mirror([0, 0, 1])
        cylinder(d=diameter * bigger, h=diameter, $fn=4);
        
        // punch hole for handle
        translate([0, 0, -epsilon])
        cylinder(d=handle_hole_diameter, h=diameter, $fn=sphere_resolution);
    }
}


module coil_sphere() {
    difference() {
        sphere(d=diameter, $fn=sphere_resolution);
        
        coil_slot();
        rotate([90, 0, 0]) coil_slot();
        rotate([0, 90, 0]) coil_slot();
    }
}

module coil_slot() {
    linear_extrude(slot_width, center=true, $fn=sphere_resolution, convexity=3)
    difference() {
        circle(d=diameter * bigger);
        circle(d=diameter - slot_depth);
    }
}