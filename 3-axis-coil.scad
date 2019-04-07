diameter = 40;
slot_width = 3;
slot_depth = 3;
sphere_resolution = 120;
handle_diameter = 10;
handle_wall = 1;
handle_facets = 3;
handle_middle_length = 100;

epsilon = 0.01;
facet_epsilon = 10;
bigger = 100;
corner_angle = asin(1/sqrt(3));

handle_socket_taper_large = handle_diameter + 0.4;
handle_socket_taper_small = handle_diameter;
handle_shaft_length = handle_middle_length + diameter * 0.75;

plate();

module plate() {
    half(true);
    translate([diameter + 5, 0, 0]) half(false);
    translate([0, (diameter + handle_diameter) / 2 + 5, 0]) handle();
    translate([-diameter - 5, 0, 0]) junction_box();
}

module handle() {
    translate([0, 0, cos(60) * handle_diameter / 2])
    rotate([0, -90, 0]) {
        difference() {
            cylinder(d=handle_diameter, h=handle_shaft_length, $fn=handle_facets, center=true);
            cylinder(
                d=handle_diameter - handle_wall * 2,
                h=handle_shaft_length + epsilon * 2,
                $fn=handle_facets,
                center=true);
        }
    }
}

module handle_hole(h, taper_1, taper_2, center=false) {
    cylinder(
        d1=taper_1 ? handle_socket_taper_small : handle_socket_taper_large,
        d2=taper_2 ? handle_socket_taper_small : handle_socket_taper_large,
        h=h,
        $fn=handle_facets,
        center=center);
}

module half(is_top_half) {
    difference() {
        rotate([0, 0, is_top_half ? 0 : 180])  // align coil slots given handle hole
        coil_sphere(is_top_half);

        // remove opposite half
        mirror([0, 0, 1])
        top_half_enclosing();
        
        // punch hole for handle
        translate([0, 0, -epsilon])
        rotate([0, 0, -30])
        handle_hole(diameter / 2 + epsilon * 2, false, is_top_half);
    }
}


module coil_sphere(include_entry) {
    difference() {
        sphere(d=diameter, $fn=sphere_resolution);
        
        coil_slot_and_entry(include_entry);
        rotate([0, 0, 120]) coil_slot_and_entry(include_entry);
        rotate([0, 0, -120]) coil_slot_and_entry(include_entry);
    }
}

module coil_slot() {
    linear_extrude(slot_width, center=true, $fn=sphere_resolution, convexity=3)
    difference() {
        circle(d=diameter + facet_epsilon);
        circle(d=diameter - slot_depth);
    }
}

module coil_slot_and_entry(include_entry) {
    rotate([90 - corner_angle, 0, 0])
    coil_slot();
    
    if (include_entry)
    render()  // faster preview
    intersection() {
        // perpendicular slot
        rotate([0, 90, 0]) coil_slot();
        
        // cut part "below" main slot
        rotate([90 - corner_angle, 0, 0])
        top_half_enclosing();
        
        // cut part beyond the middle
        rotate([-90, 0, 0]) top_half_enclosing();
    }
}

module top_half_enclosing() {
    cylinder(d=diameter * 2, h=diameter, $fn=4);
}

module junction_box() {
    box_height = handle_diameter;
    
    translate([0, 0, box_height / 2])
    difference() {
        cube([30, 30, box_height], center=true);
        
        translate([0, 0, -cos(60) * handle_diameter / 4])
        rotate([0, -90, 0])
        handle_hole(31, true, false);
    }
}