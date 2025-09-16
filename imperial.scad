////////////////////////////////////////////////////////
//        Parts Bin Label Generator - IMPERIAL        //
//         Fractional & Machine Screw Support         //
//            Version 16 - Batch All Sizes            //
////////////////////////////////////////////////////////

/* [Single Label Mode] */
hardware_type = "Button head bolt"; // [Phillips head bolt, Socket head bolt, Hex head bolt, Button head bolt, Torx head bolt, Phillips head countersunk, Torx head countersunk, Socket head countersunk, Phillips wood screw, Torx wood screw, Wall anchor, Heat set insert, Standard nut, Lock nut, Standard washer, Spring washer, Custom text, None]
thread_spec = "#4-40"; // [#4-40, #4-48, #5-40, #5-44, #6-32, #6-40, #8-32, #8-36, #10-24, #10-32, #12-24, #12-28, 1/4-20, 1/4-28, 5/16-18, 5/16-24, 3/8-16, 3/8-24, 7/16-14, 7/16-20, 1/2-13, 1/2-20, 9/16-12, 9/16-18, 5/8-11, 5/8-18, 3/4-10, 3/4-16, 7/8-9, 7/8-14, 1-8, 1-12]
length_fraction = "3/4"; // [1/4, 5/16, 3/8, 7/16, 1/2, 9/16, 5/8, 11/16, 3/4, 13/16, 7/8, 15/16, 1, 1-1/16, 1-1/8, 1-3/16, 1-1/4, 1-5/16, 1-3/8, 1-7/16, 1-1/2, 1-9/16, 1-5/8, 1-11/16, 1-3/4, 1-13/16, 1-7/8, 1-15/16, 2]
custom_display_text = ""; // Custom text override (leave blank for auto-generation)
custom_text_only = "Custom"; // Used only when hardware_type is "Custom text"

/* [Batch All Sizes Mode] */
enable_batch_all_sizes = false;
batch_hardware_type = "Phillips head bolt"; // [Phillips head bolt, Socket head bolt, Hex head bolt, Button head bolt, Torx head bolt, Phillips head countersunk, Torx head countersunk, Socket head countersunk, Phillips wood screw, Torx wood screw, Wall anchor, Heat set insert, Standard nut, Lock nut, Standard washer, Spring washer]
batch_thread_spec = "#4-40"; // [#4-40, #4-48, #5-40, #5-44, #6-32, #6-40, #8-32, #8-36, #10-24, #10-32, #12-24, #12-28, 1/4-20, 1/4-28, 5/16-18, 5/16-24, 3/8-16, 3/8-24, 7/16-14, 7/16-20, 1/2-13, 1/2-20, 9/16-12, 9/16-18, 5/8-11, 5/8-18, 3/4-10, 3/4-16, 7/8-9, 7/8-14, 1-8, 1-12]

/* [Label Properties] */
label_units = 1; // [1:Small (37.8mm), 2:Medium (75.6mm), 3:Large (113.4mm)]
base_color = "#FFFFFF"; // Base label color
content_color = "#000000"; // Text and icon color
export_mode = "Complete"; // [Complete, Base only, Content only]

/* [Typography] */
font_family = "Roboto"; // [Arial, Roboto, Open Sans, Noto Sans, Liberation Sans]
font_weight = "Bold"; // [Regular, Bold, Light, Medium]
text_size = 3.5;

/* [Advanced Settings] */
label_width = 11.7;
label_thickness = 0.8;
corner_radius = 0.9;
edge_chamfer = 0.2;
raised_height = 0.3;

// Internal calculations
label_length = (label_units == 1) ? 37.8 : (label_units == 2) ? 75.6 : 113.4;
text_height = raised_height;
font_string = str(font_family, ":style=", font_weight);
max_bolt_length = 20 * label_units;
max_text_width = label_length - 4; // Leave 2mm margin on each side for text

// Batch spacing calculations
grid_columns = (label_units == 1) ? 6 : (label_units == 2) ? 3 : 2;
h_spacing = label_length + 1; // 1mm gap between labels horizontally
v_spacing = label_width + 1;  // 1mm gap between labels vertically

// All fractional sizes for batch generation
all_fractional_sizes = ["1/4", "5/16", "3/8", "7/16", "1/2", "9/16", "5/8", "11/16", "3/4", "13/16", "7/8", "15/16", "1", "1-1/16", "1-1/8", "1-3/16", "1-1/4", "1-5/16", "1-3/8", "1-7/16", "1-1/2", "1-9/16", "1-5/8", "1-11/16", "1-3/4", "1-13/16", "1-7/8", "1-15/16", "2"];

////////////////////////////////////////////////////////
//         IMPERIAL SYSTEM FUNCTIONS                 //
////////////////////////////////////////////////////////

function imperial_to_mm(inches) = inches * 25.4;

// Convert fractional string to decimal
function fraction_to_decimal(frac_str) =
    (frac_str == "1/4") ? 0.25 :
    (frac_str == "5/16") ? 0.3125 :
    (frac_str == "3/8") ? 0.375 :
    (frac_str == "7/16") ? 0.4375 :
    (frac_str == "1/2") ? 0.5 :
    (frac_str == "9/16") ? 0.5625 :
    (frac_str == "5/8") ? 0.625 :
    (frac_str == "11/16") ? 0.6875 :
    (frac_str == "3/4") ? 0.75 :
    (frac_str == "13/16") ? 0.8125 :
    (frac_str == "7/8") ? 0.875 :
    (frac_str == "15/16") ? 0.9375 :
    (frac_str == "1") ? 1.0 :
    (frac_str == "1-1/16") ? 1.0625 :
    (frac_str == "1-1/8") ? 1.125 :
    (frac_str == "1-3/16") ? 1.1875 :
    (frac_str == "1-1/4") ? 1.25 :
    (frac_str == "1-5/16") ? 1.3125 :
    (frac_str == "1-3/8") ? 1.375 :
    (frac_str == "1-7/16") ? 1.4375 :
    (frac_str == "1-1/2") ? 1.5 :
    (frac_str == "1-9/16") ? 1.5625 :
    (frac_str == "1-5/8") ? 1.625 :
    (frac_str == "1-11/16") ? 1.6875 :
    (frac_str == "1-3/4") ? 1.75 :
    (frac_str == "1-13/16") ? 1.8125 :
    (frac_str == "1-7/8") ? 1.875 :
    (frac_str == "1-15/16") ? 1.9375 :
    (frac_str == "2") ? 2.0 :
    0.75; // Default fallback

function is_nut_or_washer_type(type) =
    type == "Standard nut" || 
    type == "Lock nut" || 
    type == "Standard washer" || 
    type == "Spring washer";

////////////////////////////////////////////////////////
//                 MAIN EXECUTION                    //
////////////////////////////////////////////////////////

if (enable_batch_all_sizes) {
    generate_batch_all_sizes();
} else {
    // Single label mode
    length_inches = fraction_to_decimal(length_fraction);
    length_mm = length_inches * 25.4;
    
    final_display_text = (custom_display_text != "") ? custom_display_text :
        is_nut_or_washer_type(hardware_type) ? "" :
        str(thread_spec, " x ", length_fraction);

    create_single_label(
        type = hardware_type,
        thread = thread_spec,
        display_text = final_display_text,
        length_mm = length_mm
    );
}

////////////////////////////////////////////////////////
//            BATCH ALL SIZES GENERATION             //
////////////////////////////////////////////////////////

module generate_batch_all_sizes() {
    num_sizes = len(all_fractional_sizes);
    
    for (i = [0 : num_sizes - 1]) {
        size_fraction = all_fractional_sizes[i];
        length_inches = fraction_to_decimal(size_fraction);
        length_mm = length_inches * 25.4;
        
        // Calculate grid position
        row = floor(i / grid_columns);
        col = i % grid_columns;
        
        // Position label in grid with tight spacing
        translate([col * h_spacing, -row * v_spacing, 0]) {
            // Generate display text - use batch parameters, not defaults
            final_display_text = is_nut_or_washer_type(batch_hardware_type) ? "" :
                str(batch_thread_spec, " x ", size_fraction);
                
            create_single_label(
                type = batch_hardware_type,
                thread = batch_thread_spec,
                display_text = final_display_text,
                length_mm = length_mm
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
    // Main label body with rounded corners (no mounting holes)
    hull() {
        for (x = [-label_length/2 + corner_radius, label_length/2 - corner_radius]) {
            for (y = [-label_width/2 + corner_radius, label_width/2 - corner_radius]) {
                translate([x, y, 0]) {
                    cylinder(h = label_thickness, r = corner_radius);
                }
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
        render_text(display_text);
    }
}

////////////////////////////////////////////////////////
//                TEXT RENDERING                     //
////////////////////////////////////////////////////////

module render_text(text_content) {
    translate([0, -label_width/2 + 3, label_thickness]) {
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
    icon_y_pos = label_width/4-1;  // Position icon closer to center and further from text
    
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

module bolt_stem(length_mm, start_x, y_pos, stem_width = 2.0) {
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
            cylinder(h = text_height, d = 4);
            translate([-1.5, -0.3, 0]) cube([3, 0.6, text_height]);
            translate([-0.3, -1.5, 0]) cube([0.6, 3, text_height]);
        }
    }
    
    translate([head_x + 5, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            intersection() {
                circle(d = 4);
                translate([-2, -2]) square([2, 4]);
            }
        }
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

module phillips_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            translate([-1.5, -0.3, 0]) cube([3, 0.6, text_height]);
            translate([-0.3, -1.5, 0]) cube([0.6, 3, text_height]);
        }
    }
    
    translate([head_x + 3, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2], [2.5, 0], [0, 2]]);
        }
    }
    
    bolt_stem(length_mm, head_x + 4, y_pos);
}

module phillips_wood_screw_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            translate([-1.5, -0.3, 0]) cube([3, 0.6, text_height]);
            translate([-0.3, -1.5, 0]) cube([0.6, 3, text_height]);
        }
    }
    
    translate([head_x + 3, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2], [2.5, 0], [0, 2]]);
        }
    }
    
    stem_length = max(0, length_mm - 2);
    if (stem_length > 0) {
        bolt_stem(stem_length, head_x + 4, y_pos);
        
        tip_x = head_x + 4 + min(stem_length, max_bolt_length);
        translate([tip_x, y_pos, z_pos]) {
            linear_extrude(height = text_height) {
                polygon(points = [[0, -1], [1.5, 0], [0, 1]]);
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
            cylinder(h = text_height, d = 4);
            cylinder(h = text_height, d = 2.5, $fn = 6);
        }
    }
    
    translate([head_x + 3, y_pos - 2, z_pos]) {
        cube([3, 4, text_height]);
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

module socket_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            cylinder(h = text_height, d = 2.5, $fn = 6);
        }
    }
    
    translate([head_x + 3, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2], [2.5, 0], [0, 2]]);
        }
    }
    
    bolt_stem(length_mm, head_x + 4, y_pos);
}

////////////////////////////////////////////////////////
//                HEX HEAD ICON                      //
////////////////////////////////////////////////////////

module hex_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        cylinder(h = text_height, d = 4, $fn = 6);
    }
    
    translate([head_x + 3, y_pos - 2, z_pos]) {
        cube([2.5, 4, text_height]);
    }
    
    bolt_stem(length_mm, head_x + 4.5, y_pos);
}

////////////////////////////////////////////////////////
//               BUTTON HEAD ICON                    //
////////////////////////////////////////////////////////

module button_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            cylinder(h = text_height, d = 2.5, $fn = 6);
        }
    }
    
    translate([head_x + 5, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            intersection() {
                circle(d = 4);
                translate([-2, -2]) square([2, 4]);
            }
        }
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

////////////////////////////////////////////////////////
//                TORX HEAD ICONS                    //
////////////////////////////////////////////////////////

module torx_star(size) {
    for (i = [0:5]) {
        rotate([0, 0, i * 60]) {
            translate([0, -size/2, 0]) {
                hull() {
                    circle(d = 0.25);
                    translate([0, size, 0]) circle(d = 0.25);
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
            cylinder(h = text_height, d = 4);
            linear_extrude(height = text_height) torx_star(2);
        }
    }
    
    translate([head_x + 3, y_pos - 2, z_pos]) {
        cube([3, 4, text_height]);
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

module torx_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            linear_extrude(height = text_height) torx_star(2);
        }
    }
    
    translate([head_x + 3, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2], [2.5, 0], [0, 2]]);
        }
    }
    
    bolt_stem(length_mm, head_x + 4, y_pos);
}

module torx_wood_screw_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            linear_extrude(height = text_height) torx_star(2);
        }
    }
    
    translate([head_x + 3, y_pos, z_pos]) {
        linear_extrude(height = text_height) {
            polygon(points = [[0, -2], [2.5, 0], [0, 2]]);
        }
    }
    
    stem_length = max(0, length_mm - 2);
    if (stem_length > 0) {
        bolt_stem(stem_length, head_x + 4, y_pos);
        
        tip_x = head_x + 4 + min(stem_length, max_bolt_length);
        translate([tip_x, y_pos, z_pos]) {
            linear_extrude(height = text_height) {
                polygon(points = [[0, -1], [1.5, 0], [0, 1]]);
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
        translate([start_x + i * 1.5, y_pos, z_pos]) {
            linear_extrude(height = text_height) {
                polygon(points = [[-0.75, -1.5], [0.75, -1.25], [0.75, 1.25], [-0.75, 1.5]]);
            }
        }
    }
    
    if (length_mm > 6) {
        translate([start_x + 6, y_pos - 1.25, z_pos]) {
            cube([min(length_mm - 6, max_bolt_length - 6), 2.5, text_height]);
        }
    }
}

module heat_insert_icon(length_mm, y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1.5, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 3);
            cylinder(h = text_height, d = 2);
        }
    }
    
    for (i = [0:2]) {
        translate([center_x + 1.5 + i * 1.5, y_pos - 1.5, z_pos]) {
            cube([0.75, 3, text_height]);
        }
    }
}

////////////////////////////////////////////////////////
//              NUTS AND WASHERS                     //
////////////////////////////////////////////////////////

module standard_nut_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1.5, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 6);
            cylinder(h = text_height, d = 2.5);
        }
    }
    
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([2.5, 4, text_height]);
    }
}

module lock_nut_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1.5, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 6);
            cylinder(h = text_height, d = 2.5);
        }
    }
    
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([2.5, 4, text_height]);
    }
    translate([center_x + 1.5, y_pos - 1.5, z_pos]) {
        cube([3, 3, text_height]);
    }
}

module standard_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            cylinder(h = text_height, d = 2.5);
        }
    }
    
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([0.75, 4, text_height]);
    }
}

module spring_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4);
            cylinder(h = text_height, d = 2.5);
            translate([0, -0.3, 0]) cube([4, 0.6, text_height]);
        }
    }
    
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([0.75, 4, text_height]);
    }
}
