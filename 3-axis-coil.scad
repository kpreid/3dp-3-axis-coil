diameter = 40;
slot_width = 3;
slot_depth = 3;
sphere_resolution = 120;
handle_diameter = 10;
handle_facets = 3;

epsilon = 0.01;
facet_epsilon = 10;
bigger = 100;
corner_angle = asin(1/sqrt(3));

handle_socket_taper_large = handle_diameter + 0.4;
handle_socket_taper_small = handle_diameter;


half();


module half() {
    difference() {
        coil_sphere();

        // remove symmetric bottom half
        mirror([0, 0, 1])
        top_half_enclosing();
        
        // punch hole for handle
        translate([0, 0, -epsilon])
        rotate([0, 0, 30])
        cylinder(d1=handle_socket_taper_large, d2=handle_socket_taper_small, h=diameter / 2 + epsilon * 2, $fn=handle_facets);
    }
}


module coil_sphere() {
    difference() {
        sphere(d=diameter, $fn=sphere_resolution);
        
        coil_slot_and_entry();
        rotate([0, 0, 120]) coil_slot_and_entry();
        rotate([0, 0, -120]) coil_slot_and_entry();
    }
}

module coil_slot() {
    linear_extrude(slot_width, center=true, $fn=sphere_resolution, convexity=3)
    difference() {
        circle(d=diameter + facet_epsilon);
        circle(d=diameter - slot_depth);
    }
}

module coil_slot_and_entry() {
    rotate([90 - corner_angle, 0, 0])
    coil_slot();
    
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