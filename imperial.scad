////////////////////////////////////////////////////////
//        Parts Bin Label Generator - IMPERIAL        //
//         Fractional & Machine Screw Support         //
////////////////////////////////////////////////////////

/* [Single Label Mode] */
hardware_type = "Button head bolt"; // [Phillips head bolt, Socket head bolt, Hex head bolt, Button head bolt, Torx head bolt, Phillips head countersunk, Torx head countersunk, Socket head countersunk, Phillips wood screw, Torx wood screw, Wall anchor, Heat set insert, Standard nut, Lock nut, Standard washer, Spring washer, Custom text, None]
thread_spec = "1/4-20"; // [1/4-20, 5/16-18, 3/8-16, 7/16-14, 1/2-13, 9/16-12, 5/8-11, 3/4-10, 7/8-9, 1-8, #4-40, #5-40, #6-32, #8-32, #10-24, #12-24]
length_inches = 0.75; // Length in inches
custom_display_text = ""; // Custom text override (leave blank for auto-generation)
custom_text_only = "Custom"; // Used only when hardware_type is "Custom text"

/* [Multi-Label Mode] */
enable_multi_label = false;
multi_label_prompt = "Create socket head bolt labels: 1/4-20 x 1/2, 3/4, 1 inch and #8-32 x 1/2, 3/4 inch. Generate nuts: 1/4-20, #8-32, #10-24. Make washers for same sizes."; // Natural language description

/* [Label Properties] */
label_units = 1; // [1:Small (35.8mm), 2:Medium (77.8mm), 3:Large (119.8mm)]
base_color = "#2C3E50"; // Base label color
content_color = "#FFFFFF"; // Text and icon color
export_mode = "Complete"; // [Complete, Base only, Content only]

/* [Typography] */
font_family = "Roboto"; // [Arial, Roboto, Open Sans, Noto Sans, Liberation Sans]
font_weight = "Bold"; // [Regular, Bold, Light, Medium]
text_size = 4.0;
text_mode = "Raised"; // [Raised, Flush]

/* [Advanced Settings] */
label_width = 11.5;
label_thickness = 0.8;
corner_radius = 0.9;
edge_chamfer = 0.2;
raised_height = 0.2;
flush_height = 0.01;
hole_diameter = 1.5;

// Internal calculations
label_length = (label_units == 1) ? 35.8 : (label_units == 2) ? 77.8 : 119.8;
text_height = (text_mode == "Raised") ? raised_height : flush_height;
font_string = str(font_family, ":style=", font_weight);
max_bolt_length = 20 * label_units;
length_mm = length_inches * 25.4; // Convert to mm for internal calculations

////////////////////////////////////////////////////////
//         IMPERIAL SYSTEM FUNCTIONS                 //
////////////////////////////////////////////////////////

function imperial_to_mm(inches) = inches * 25.4;

function generate_imperial_display_text(thread, length_inches) =
    (length_inches == 0.125) ? str(thread, " x 1/8\"") :
    (length_inches == 0.1875) ? str(thread, " x 3/16\"") :
    (length_inches == 0.25) ? str(thread, " x 1/4\"") :
    (length_inches == 0.3125) ? str(thread, " x 5/16\"") :
    (length_inches == 0.375) ? str(thread, " x 3/8\"") :
    (length_inches == 0.4375) ? str(thread, " x 7/16\"") :
    (length_inches == 0.5) ? str(thread, " x 1/2\"") :
    (length_inches == 0.5625) ? str(thread, " x 9/16\"") :
    (length_inches == 0.625) ? str(thread, " x 5/8\"") :
    (length_inches == 0.6875) ? str(thread, " x 11/16\"") :
    (length_inches == 0.75) ? str(thread, " x 3/4\"") :
    (length_inches == 0.8125) ? str(thread, " x 13/16\"") :
    (length_inches == 0.875) ? str(thread, " x 7/8\"") :
    (length_inches == 0.9375) ? str(thread, " x 15/16\"") :
    (length_inches == 1.0) ? str(thread, " x 1\"") :
    (length_inches == 1.25) ? str(thread, " x 1-1/4\"") :
    (length_inches == 1.5) ? str(thread, " x 1-1/2\"") :
    (length_inches == 1.75) ? str(thread, " x 1-3/4\"") :
    (length_inches == 2.0) ? str(thread, " x 2\"") :
    str(thread, " x ", length_inches, "\""); // Default for custom lengths

function is_nut_or_washer_type(type) =
    type == "Standard nut" || 
    type == "Lock nut" || 
    type == "Standard washer" || 
    type == "Spring washer";

////////////////////////////////////////////////////////
//    IMPERIAL MULTI-LABEL PARSER                    //
////////////////////////////////////////////////////////

function parse_multi_label_prompt(prompt) =
    // Enhanced parser for imperial specifications including fine threads
    [
        // Coarse thread fractional bolts
        ["Socket head bolt", "1/4-20", "1/4-20 x 1/2\"", 12.7],
        ["Socket head bolt", "1/4-20", "1/4-20 x 3/4\"", 19.05],
        ["Socket head bolt", "1/4-20", "1/4-20 x 1\"", 25.4],
        
        // Fine thread fractional bolts
        ["Socket head bolt", "1/4-28", "1/4-28 x 1/2\"", 12.7],
        ["Socket head bolt", "1/4-28", "1/4-28 x 3/4\"", 19.05],
        
        // Coarse thread machine screws
        ["Socket head bolt", "#8-32", "#8-32 x 1/2\"", 12.7],
        ["Socket head bolt", "#8-32", "#8-32 x 3/4\"", 19.05],
        
        // Fine thread machine screws
        ["Socket head bolt", "#8-36", "#8-36 x 1/2\"", 12.7],
        ["Socket head bolt", "#8-36", "#8-36 x 5/8\"", 15.875],
        
        // Nuts - coarse and fine threads
        ["Standard nut", "1/4-20", "", 0],
        ["Standard nut", "1/4-28", "", 0],
        ["Standard nut", "#8-32", "", 0],
        ["Standard nut", "#8-36", "", 0],
        ["Standard nut", "#10-24", "", 0],
        ["Standard nut", "#10-32", "", 0],
        
        // Washers - coarse and fine threads
        ["Standard washer", "1/4-20", "", 0],
        ["Standard washer", "1/4-28", "", 0],
        ["Standard washer", "#8-32", "", 0],
        ["Standard washer", "#8-36", "", 0]
    ];

////////////////////////////////////////////////////////
//                 MAIN EXECUTION                    //
////////////////////////////////////////////////////////

if (enable_multi_label) {
    generate_multi_labels();
} else {
    // Generate display text if not provided
    final_display_text = (custom_display_text != "") ? custom_display_text :
        is_nut_or_washer_type(hardware_type) ? "" :
        generate_imperial_display_text(thread_spec, length_inches);
    
    create_single_label(
        type = hardware_type,
        thread = thread_spec,
        display_text = final_display_text,
        length_mm = length_mm
    );
}

////////////////////////////////////////////////////////
//              MULTI-LABEL GENERATION               //
////////////////////////////////////////////////////////

module generate_multi_labels() {
    parsed_specs = parse_multi_label_prompt(multi_label_prompt);
    
    grid_columns = 3;
    h_spacing = label_length + 4;
    v_spacing = 15;
    
    for (i = [0 : len(parsed_specs) - 1]) {
        spec = parsed_specs[i];
        row = floor(i / grid_columns);
        col = i % grid_columns;
        
        translate([col * h_spacing, -row * v_spacing, 0]) {
            create_single_label(
                type = spec[0],
                thread = spec[1], 
                display_text = spec[2],
                length_mm = spec[3]
            );
        }
    }
}

////////////////////////////////////////////////////////
//              SINGLE LABEL CREATION                //
////////////////////////////////////////////////////////

module create_single_label(type, thread, display_text, length_mm) {
    // Base structure
    if (export_mode == "Complete" || export_mode == "Base only") {
        color(base_color) {
            label_base();
        }
    }
    
    // Content (text and icons)
    if (export_mode == "Complete" || export_mode == "Content only") {
        color(content_color) {
            label_content(type, thread, display_text, length_mm);
        }
    }
}

////////////////////////////////////////////////////////
//                LABEL BASE                         //
////////////////////////////////////////////////////////

module label_base() {
    difference() {
        // Main label body with rounded corners
        hull() {
            for (x = [-label_length/2 + corner_radius, label_length/2 - corner_radius]) {
                for (y = [-label_width/2 + corner_radius, label_width/2 - corner_radius]) {
                    translate([x, y, 0]) {
                        cylinder(h = label_thickness, r = corner_radius);
                    }
                }
            }
        }
        
        // Mounting holes
        for (x = [-(label_length-2)/2, (label_length-2)/2]) {
            translate([x, 0, -0.1]) {
                cylinder(h = label_thickness + 0.2, d = hole_diameter);
            }
        }
    }
}

////////////////////////////////////////////////////////
//               LABEL CONTENT                       //
////////////////////////////////////////////////////////

module label_content(type, thread, display_text, length_mm) {
    if (type == "Custom text") {
        render_text(custom_text_only);
    } else if (is_nut_or_washer_type(type)) {
        render_hardware_icon(type, length_mm);
        render_text(thread);
    } else {
        // Bolts and screws
        render_hardware_icon(type, length_mm);
        final_text = (display_text != "") ? display_text : str(thread, " x ", length_inches, "\"");
        render_text(final_text);
    }
}

////////////////////////////////////////////////////////
//                TEXT RENDERING                     //
////////////////////////////////////////////////////////

module render_text(text_content) {
    translate([0, -label_width/2 + 2, label_thickness]) {
        linear_extrude(height = text_height) {
            text(text_content, 
                 size = text_size,
                 font = font_string,
                 halign = "center",
                 valign = "center");
        }
    }
}

////////////////////////////////////////////////////////
//               HARDWARE ICONS                      //
////////////////////////////////////////////////////////

module render_hardware_icon(type, length_mm) {
    icon_y_pos = label_width/4;
    
    if (type == "Phillips head bolt") {
        phillips_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Socket head bolt") {
        socket_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Hex head bolt") {
        hex_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Button head bolt") {
        button_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Torx head bolt") {
        torx_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Phillips head countersunk") {
        phillips_countersunk_icon(length_mm, icon_y_pos);
    } else if (type == "Torx head countersunk") {
        torx_countersunk_icon(length_mm, icon_y_pos);
    } else if (type == "Socket head countersunk") {
        socket_countersunk_icon(length_mm, icon_y_pos);
    } else if (type == "Phillips wood screw") {
        phillips_wood_screw_icon(length_mm, icon_y_pos);
    } else if (type == "Torx wood screw") {
        torx_wood_screw_icon(length_mm, icon_y_pos);
    } else if (type == "Wall anchor") {
        wall_anchor_icon(length_mm, icon_y_pos);
    } else if (type == "Heat set insert") {
        heat_insert_icon(length_mm, icon_y_pos);
    } else if (type == "Standard nut") {
        standard_nut_icon(icon_y_pos);
    } else if (type == "Lock nut") {
        lock_nut_icon(icon_y_pos);
    } else if (type == "Standard washer") {
        standard_washer_icon(icon_y_pos);
    } else if (type == "Spring washer") {
        spring_washer_icon(icon_y_pos);
    }
}

////////////////////////////////////////////////////////
//              BOLT STEM HELPER                     //
////////////////////////////////////////////////////////

module bolt_stem(length_mm, start_x, y_pos, stem_width = 2.5) {
    effective_length = min(length_mm, max_bolt_length);
    z_pos = label_thickness;
    
    if (length_mm > max_bolt_length) {
        // Split stem for long bolts
        gap = 2;
        segment_len = (effective_length - gap) / 2;
        
        translate([start_x, y_pos - stem_width/2, z_pos]) {
            cube([segment_len, stem_width, text_height]);
        }
        
        translate([start_x + segment_len + gap, y_pos - stem_width/2, z_pos]) {
            cube([segment_len, stem_width, text_height]);
        }
    } else {
        translate([start_x, y_pos - stem_width/2, z_pos]) {
            cube([effective_length, stem_width, text_height]);
        }
    }
}

////////////////////////////////////////////////////////
//               PHILLIPS HEAD ICONS                 //
////////////////////////////////////////////////////////

module phillips_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            translate([-2, -0.4, 0]) cube([4, 0.8, text_height]);
            translate([-0.4, -2, 0]) cube([0.8, 4, text_height]);
        }
    }
    
    translate([head_x + 3.5, y_pos, z_pos]) {
        intersection() {
            cylinder(h = text_height, d = 5);
            translate([0, -2.5, 0]) cube([5, 5, text_height]);
        }
    }
    
    bolt_stem(length_mm, head_x + 6, y_pos);
}

module phillips_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            translate([-2, -0.4, 0]) cube([4, 0.8, text_height]);
            translate([-0.4, -2, 0]) cube([0.8, 4, text_height]);
        }
    }
    
    translate([head_x + 4, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2.5], [3, 0], [0, 2.5]]);
        }
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

module phillips_wood_screw_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            translate([-2, -0.4, 0]) cube([4, 0.8, text_height]);
            translate([-0.4, -2, 0]) cube([0.8, 4, text_height]);
        }
    }
    
    translate([head_x + 4, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2.5], [3, 0], [0, 2.5]]);
        }
    }
    
    stem_length = max(0, length_mm - 2);
    if (stem_length > 0) {
        bolt_stem(stem_length, head_x + 5, y_pos);
        
        tip_x = head_x + 5 + min(stem_length, max_bolt_length);
        translate([tip_x, y_pos, z_pos]) {
            linear_extrude(height = text_height) {
                polygon(points = [[0, -1.25], [2, 0], [0, 1.25]]);
            }
        }
    }
}

////////////////////////////////////////////////////////
//                SOCKET HEAD ICONS                  //
////////////////////////////////////////////////////////

module socket_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            cylinder(h = text_height, d = 3, $fn = 6);
        }
    }
    
    translate([head_x + 3.5, y_pos - 2.5, z_pos]) {
        cube([4, 5, text_height]);
    }
    
    bolt_stem(length_mm, head_x + 6, y_pos);
}

module socket_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            cylinder(h = text_height, d = 3, $fn = 6);
        }
    }
    
    translate([head_x + 4, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2.5], [3, 0], [0, 2.5]]);
        }
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

////////////////////////////////////////////////////////
//                HEX HEAD ICON                      //
////////////////////////////////////////////////////////

module hex_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        cylinder(h = text_height, d = 5, $fn = 6);
    }
    
    translate([head_x + 3.5, y_pos - 2.5, z_pos]) {
        cube([3, 5, text_height]);
    }
    
    bolt_stem(length_mm, head_x + 5.5, y_pos);
}

////////////////////////////////////////////////////////
//               BUTTON HEAD ICON                    //
////////////////////////////////////////////////////////

module button_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            cylinder(h = text_height, d = 3, $fn = 6);
        }
    }
    
    translate([head_x + 3.5, y_pos, z_pos]) {
        intersection() {
            scale([1, 1, 0.6]) cylinder(h = text_height * 1.67, d = 5);
            translate([0, -2.5, 0]) cube([5, 5, text_height]);
        }
    }
    
    bolt_stem(length_mm, head_x + 6, y_pos);
}

////////////////////////////////////////////////////////
//                TORX HEAD ICONS                    //
////////////////////////////////////////////////////////

module torx_star(size) {
    for (i = [0:5]) {
        rotate([0, 0, i * 60]) {
            translate([0, -size/2, 0]) {
                hull() {
                    circle(d = 0.3);
                    translate([0, size, 0]) circle(d = 0.3);
                }
            }
        }
    }
}

module torx_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            linear_extrude(height = text_height) torx_star(2.5);
        }
    }
    
    translate([head_x + 3.5, y_pos - 2.5, z_pos]) {
        cube([4, 5, text_height]);
    }
    
    bolt_stem(length_mm, head_x + 6, y_pos);
}

module torx_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            linear_extrude(height = text_height) torx_star(2.5);
        }
    }
    
    translate([head_x + 4, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2.5], [3, 0], [0, 2.5]]);
        }
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

module torx_wood_screw_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            linear_extrude(height = text_height) torx_star(2.5);
        }
    }
    
    translate([head_x + 4, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2.5], [3, 0], [0, 2.5]]);
        }
    }
    
    stem_length = max(0, length_mm - 2);
    if (stem_length > 0) {
        bolt_stem(stem_length, head_x + 5, y_pos);
        
        tip_x = head_x + 5 + min(stem_length, max_bolt_length);
        translate([tip_x, y_pos, z_pos]) {
            linear_extrude(height = text_height) {
                polygon(points = [[0, -1.25], [2, 0], [0, 1.25]]);
            }
        }
    }
}

////////////////////////////////////////////////////////
//            SPECIALIZED HARDWARE                   //
////////////////////////////////////////////////////////

module wall_anchor_icon(length_mm, y_pos) {
    z_pos = label_thickness;
    start_x = -min(length_mm, max_bolt_length)/2 - 4;
    
    for (i = [0:4]) {
        translate([start_x + i * 2, y_pos, z_pos]) {
            linear_extrude(height = text_height) {
                polygon(points = [[-1, -2], [1, -1.5], [1, 1.5], [-1, 2]]);
            }
        }
    }
    
    if (length_mm > 8) {
        translate([start_x + 8, y_pos - 1.5, z_pos]) {
            cube([min(length_mm - 8, max_bolt_length - 8), 3, text_height]);
        }
    }
}

module heat_insert_icon(length_mm, y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 2, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            cylinder(h = text_height, d = 2.5);
        }
    }
    
    for (i = [0:3]) {
        translate([center_x + 2 + i * 2, y_pos - 2, z_pos]) {
            cube([1, 4, text_height]);
        }
    }
}

////////////////////////////////////////////////////////
//              NUTS AND WASHERS                     //
////////////////////////////////////////////////////////

module standard_nut_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 2, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5, $fn = 6);
            cylinder(h = text_height, d = 3);
        }
    }
    
    translate([center_x + 2, y_pos - 2.5, z_pos]) {
        cube([3, 5, text_height]);
    }
}

module lock_nut_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 2, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5, $fn = 6);
            cylinder(h = text_height, d = 3);
        }
    }
    
    translate([center_x + 2, y_pos - 2.5, z_pos]) {
        cube([3, 5, text_height]);
    }
    translate([center_x + 2, y_pos - 2, z_pos]) {
        cube([4, 4, text_height]);
    }
}

module standard_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            cylinder(h = text_height, d = 3);
        }
    }
    
    translate([center_x + 2, y_pos - 2.5, z_pos]) {
        cube([1, 5, text_height]);
    }
}

module spring_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 5);
            cylinder(h = text_height, d = 3);
            translate([0, -0.4, 0]) cube([5, 0.8, text_height]);
        }
    }
    
    translate([center_x + 2, y_pos - 2.5, z_pos]) {
        cube([1, 5, text_height]);
    }
}
