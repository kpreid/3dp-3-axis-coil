diameter = 40;
slot_width = 3;
slot_depth = 3;
sphere_resolution = 120;

main();

module main() {
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
        circle(d=1000);
        circle(d=diameter - slot_depth);
    }
}