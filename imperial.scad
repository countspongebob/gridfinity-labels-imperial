////////////////////////////////////////////////////////
//        Parts Bin Label Generator - IMPERIAL        //
//         Fractional & Machine Screw Support         //
//                     Version 99                     //
////////////////////////////////////////////////////////

// Debug: Verify file loads
echo("=== Version 99 Loaded Successfully ===");
echo("=== If you see this in console, file is working ===");

/* [Single Label Mode] */
hardware_type = "Button head screw"; // [Phillips head screw, Socket head bolt, Hex head bolt, Button head screw, Torx head bolt, Phillips head countersunk, Torx head countersunk, Socket head countersunk, Phillips wood screw, Torx wood screw, Wall anchor, Heat set insert, Standard nut, Jam nut, Lock nut, Standard washer, SAE washer, Lock washer, Custom text, None]
thread_spec = "#4-40"; // [#4-40, #4-48, #5-40, #5-44, #6-32, #6-40, #8-32, #8-36, #10-24, #10-32, #12-24, #12-28, 1/4-20, 1/4-28, 5/16-18, 5/16-24, 3/8-16, 3/8-24, 7/16-14, 7/16-20, 1/2-13, 1/2-20, 9/16-12, 9/16-18, 5/8-11, 5/8-18, 3/4-10, 3/4-16, 7/8-9, 7/8-14, 1-8, 1-12]
length_fraction = "3/4"; // [1/4, 5/16, 3/8, 7/16, 1/2, 9/16, 5/8, 11/16, 3/4, 13/16, 7/8, 15/16, 1, 1-1/16, 1-1/8, 1-3/16, 1-1/4, 1-5/16, 1-3/8, 1-7/16, 1-1/2, 1-9/16, 1-5/8, 1-11/16, 1-3/4, 1-13/16, 1-7/8, 1-15/16, 2, 2-1/4, 2-1/2, 2-3/4, 3, 3-1/4, 3-1/2, 3-3/4, 4, 4-1/4, 4-1/2, 4-3/4, 5, 5-1/4, 5-1/2, 5-3/4, 6, 6-1/4, 6-1/2, 6-3/4, 7, 7-1/4, 7-1/2, 7-3/4, 8]
custom_display_text = ""; // Custom text override (leave blank for auto-generation)
custom_text_only = "Custom"; // Used only when hardware_type is "Custom text"

/* [Batch All Sizes Mode] */
enable_batch_all_sizes = false;
batch_hardware_type = "Phillips head screw"; // [Phillips head screw, Socket head bolt, Hex head bolt, Button head screw, Torx head bolt, Phillips head countersunk, Torx head countersunk, Socket head countersunk, Phillips wood screw, Torx wood screw, Wall anchor, Heat set insert, Standard nut, Jam nut, Lock nut, Standard washer, SAE washer, Lock washer]
batch_thread_spec = "#4-40"; // [#4-40, #4-48, #5-40, #5-44, #6-32, #6-40, #8-32, #8-36, #10-24, #10-32, #12-24, #12-28, 1/4-20, 1/4-28, 5/16-18, 5/16-24, 3/8-16, 3/8-24, 7/16-14, 7/16-20, 1/2-13, 1/2-20, 9/16-12, 9/16-18, 5/8-11, 5/8-18, 3/4-10, 3/4-16, 7/8-9, 7/8-14, 1-8, 1-12]

/* [Label Properties] */
label_units = 1; // [1:Small (35.8mm), 2:Medium (77.4mm), 3:Large (113.4mm)]
base_color = "#FFFFFF"; // Base label color
content_color = "#000000"; // Text and icon color
export_mode = "Complete"; // [Complete, Base only, Content only]

/* [Typography] */
font_family = "Roboto"; // [Arial, Roboto, Open Sans, Noto Sans, Liberation Sans]
font_weight = "Bold"; // [Regular, Bold, Light, Medium]
text_size = 3.5;

/* [Advanced Settings] */
label_width = 11.7;
label_thickness = 0.65;  // Changed from 0.8mm to 0.65mm
corner_radius = 2.0;
edge_chamfer = 0.2;
raised_height = 0.3;
enable_side_tabs = true; // Enable rectangular tabs on sides
tab_depth = 1.0; // How far tabs extend from label edge (mm)
tab_width = 6.0; // Width of rectangular tabs (mm)

// Internal calculations
label_length = (label_units == 1) ? 35.8 : (label_units == 2) ? 77.4 : 113.4;  // Changed small from 37.8 to 35.8
text_height = raised_height;
font_string = str(font_family, ":style=", font_weight);
max_bolt_length = 20 * label_units;
max_text_width = label_length - 4; // Leave 2mm margin on each side for text

// Batch spacing calculations
grid_columns = (label_units == 1) ? 6 : (label_units == 2) ? 3 : 2;
h_spacing = label_length + 4; // Increased gap to account for side tabs (was +1, now +4)
v_spacing = label_width + 1;  // 1mm gap between labels vertically

// All fractional sizes for batch generation
all_fractional_sizes = ["1/4", "5/16", "3/8", "7/16", "1/2", "9/16", "5/8", "11/16", "3/4", "13/16", "7/8", "15/16", "1", "1-1/16", "1-1/8", "1-3/16", "1-1/4", "1-5/16", "1-3/8", "1-7/16", "1-1/2", "1-9/16", "1-5/8", "1-11/16", "1-3/4", "1-13/16", "1-7/8", "1-15/16", "2", "2-1/4", "2-1/2", "2-3/4", "3", "3-1/4", "3-1/2", "3-3/4", "4", "4-1/4", "4-1/2", "4-3/4", "5", "5-1/4", "5-1/2", "5-3/4", "6", "6-1/4", "6-1/2", "6-3/4", "7", "7-1/4", "7-1/2", "7-3/4", "8"];

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
    (frac_str == "2-1/4") ? 2.25 :
    (frac_str == "2-1/2") ? 2.5 :
    (frac_str == "2-3/4") ? 2.75 :
    (frac_str == "3") ? 3.0 :
    (frac_str == "3-1/4") ? 3.25 :
    (frac_str == "3-1/2") ? 3.5 :
    (frac_str == "3-3/4") ? 3.75 :
    (frac_str == "4") ? 4.0 :
    (frac_str == "4-1/4") ? 4.25 :
    (frac_str == "4-1/2") ? 4.5 :
    (frac_str == "4-3/4") ? 4.75 :
    (frac_str == "5") ? 5.0 :
    (frac_str == "5-1/4") ? 5.25 :
    (frac_str == "5-1/2") ? 5.5 :
    (frac_str == "5-3/4") ? 5.75 :
    (frac_str == "6") ? 6.0 :
    (frac_str == "6-1/4") ? 6.25 :
    (frac_str == "6-1/2") ? 6.5 :
    (frac_str == "6-3/4") ? 6.75 :
    (frac_str == "7") ? 7.0 :
    (frac_str == "7-1/4") ? 7.25 :
    (frac_str == "7-1/2") ? 7.5 :
    (frac_str == "7-3/4") ? 7.75 :
    (frac_str == "8") ? 8.0 :
    0.75; // Default fallback

function is_nut_or_washer_type(type) =
    type == "Standard nut" || 
    type == "Jam nut" ||
    type == "Lock nut" || 
    type == "Standard washer" || 
    type == "SAE washer" ||
    type == "Lock washer";

function is_washer_type(type) =
    type == "Standard washer" || 
    type == "SAE washer" ||
    type == "Lock washer";

// Extract size from thread spec (e.g., "3/4-10" -> "3/4", "#8-32" -> "#8")
function get_size_from_thread(thread) =
    let(dash_pos = search("-", thread))
    (len(dash_pos) > 0) ? substr(thread, 0, dash_pos[0]) : thread;

// Helper function to extract substring (OpenSCAD doesn't have substr built-in)
function substr(str, start, end) = 
    (start >= len(str) || start >= end) ? "" :
    (start == 0 && end >= len(str)) ? str :
    chr([for (i = [start:min(end-1, len(str)-1)]) ord(str[i])]);

////////////////////////////////////////////////////////
//                 MAIN EXECUTION                    //
////////////////////////////////////////////////////////

if (enable_batch_all_sizes) {
    generate_batch_all_sizes();
} else {
    // Single label mode
    length_inches = fraction_to_decimal(length_fraction);
    length_mm = length_inches * 25.4;
    
    // FIXED: Now properly handles custom text for nuts/washers
    final_display_text = (custom_display_text != "") ? custom_display_text :
        is_nut_or_washer_type(hardware_type) ? thread_spec :  // Changed from "" to thread_spec
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
            // FIXED: Also updated batch mode to use thread_spec for nuts/washers
            final_display_text = is_nut_or_washer_type(batch_hardware_type) ? batch_thread_spec :
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
                    cylinder(h = label_thickness, r = corner_radius, $fn = 32);
                }
            }
        }
    }
    
    // Add side tabs if enabled
    if (enable_side_tabs) {
        // Left side tab - centered
        translate([-label_length/2 - tab_depth, -tab_width/2, 0]) {
            cube([tab_depth, tab_width, label_thickness]);
        }
        
        // Right side tab - centered
        translate([label_length/2, -tab_width/2, 0]) {
            cube([tab_depth, tab_width, label_thickness]);
        }
    }
}

////////////////////////////////////////////////////////
//               LABEL CONTENT                       //
////////////////////////////////////////////////////////

module label_content(type, thread, display_text, length_mm) {
    if (type == "Custom text") {
        render_text(custom_text_only);
    } else if (is_washer_type(type)) {
        // Washers: icon on top, size + type on bottom
        render_hardware_icon(type, length_mm);
        // Extract just the size (no thread pitch) and add washer type
        size_only = get_size_from_thread(thread);
        washer_text = (type == "SAE washer") ? str(size_only, " SAE") :
                      (type == "Standard washer") ? str(size_only, " Standard") :
                      (type == "Lock washer") ? str(size_only, " Lock") : thread;
        // Use custom_display_text if provided, otherwise use formatted washer text
        final_text = (custom_display_text != "") ? custom_display_text : washer_text;
        render_text(final_text);
    } else if (is_nut_or_washer_type(type)) {
        // Nuts: show full thread spec
        render_hardware_icon(type, length_mm);
        render_text(display_text);
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
    
    if (type == "Phillips head screw") {
        phillips_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Socket head bolt") {
        socket_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Hex head bolt") {
        hex_bolt_icon(length_mm, icon_y_pos);
    } else if (type == "Button head screw") {
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
    } else if (type == "Jam nut") {
        jam_nut_icon(icon_y_pos);
    } else if (type == "Lock nut") {
        lock_nut_icon(icon_y_pos);
    } else if (type == "Standard washer") {
        standard_washer_icon(icon_y_pos);
    } else if (type == "SAE washer") {
        sae_washer_icon(icon_y_pos);
    } else if (type == "Lock washer") {
        lock_washer_icon(icon_y_pos);
    }
}

////////////////////////////////////////////////////////
//              BOLT STEM HELPER                     //
////////////////////////////////////////////////////////

module bolt_stem(length_mm, start_x, y_pos, stem_width = 2.0) {
    effective_length = min(length_mm, max_bolt_length);
    z_pos = label_thickness;
    
    // Always show continuous stem, capped at max_bolt_length
    translate([start_x, y_pos - stem_width/2, z_pos]) {
        cube([effective_length, stem_width, text_height]);
    }
}

////////////////////////////////////////////////////////
//               PHILLIPS HEAD ICONS                 //
////////////////////////////////////////////////////////

module phillips_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    // Top view - round head with Phillips cross
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Round head
            translate([-1.5, -0.3, 0]) cube([3, 0.6, text_height]);
            translate([-0.3, -1.5, 0]) cube([0.6, 3, text_height]);
        }
    }
    
    // Side view - rounded dome head (like button head)
    translate([head_x + 5, y_pos, z_pos]) {  // Moved from +3 to +5 to connect with stem
        linear_extrude(height = text_height) {
            intersection() {
                circle(d = 4, $fn = 32);
                translate([-2, -2]) square([2, 4]);  // Keep LEFT half for proper dome orientation
            }
        }
    }
    
    bolt_stem(length_mm, head_x + 5, y_pos);
}

module phillips_countersunk_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 2;
    z_pos = label_thickness;
    
    // Top view - round head with Phillips cross
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Round head
            translate([-1.5, -0.3, 0]) cube([3, 0.6, text_height]);
            translate([-0.3, -1.5, 0]) cube([0.6, 3, text_height]);
        }
    }
    
    // Side view - angled countersunk profile
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
    
    // Top view - round head with hex socket
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Round head
            cylinder(h = text_height, d = 2.5, $fn = 6);  // Hex socket
        }
    }
    
    // Side view - cylindrical head
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
    
    // Top view - round head with hex socket
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Round head
            cylinder(h = text_height, d = 2.5, $fn = 6);  // Hex socket
        }
    }
    
    // Side view - original logic restored
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
    // More accurate Torx pattern with rounded lobes
    difference() {
        circle(d = size * 2.2);
        for (i = [0:5]) {
            rotate([0, 0, i * 60 + 30]) {
                translate([size * 1.1, 0, 0]) {
                    circle(d = size * 0.8, $fn = 16);
                }
            }
        }
    }
}

module torx_bolt_icon(length_mm, y_pos) {
    head_x = -min(length_mm, max_bolt_length)/2 - 3;
    z_pos = label_thickness;
    
    // Top view - round head with Torx star socket
    translate([head_x, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Smooth round head
            linear_extrude(height = text_height) torx_star(1.5);  // Improved Torx pattern
        }
    }
    
    // Side view - cylindrical head
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
    
    // Top view - hex outside, smooth circular hole inside
    translate([center_x - 1.5, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 6);
            cylinder(h = text_height, d = 2.5, $fn = 32);  // Smooth circular hole
        }
    }
    
    // Side view - simple rectangular profile
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([2.5, 4, text_height]);
    }
}

module jam_nut_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    // Top view - hex outside, smooth circular hole inside (same as standard nut)
    translate([center_x - 1.5, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 6);
            cylinder(h = text_height, d = 2.5, $fn = 32);  // Smooth circular hole
        }
    }
    
    // Side view - half width compared to standard nut
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([1.25, 4, text_height]);  // Half the width of standard nut (1.25 vs 2.5)
    }
}

module lock_nut_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    // Top view - hex outside, smooth circular hole inside
    translate([center_x - 1.5, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 6);
            cylinder(h = text_height, d = 2.5, $fn = 32);  // Smooth circular hole
        }
    }
    
    // Side view - shows nylon insert at top
    // Base hex portion
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([2, 4, text_height]);
    }
    // Nylon insert portion (slightly narrower, at top)
    translate([center_x + 3.5, y_pos - 1.5, z_pos]) {
        cube([1.5, 3, text_height]);
    }
}

module standard_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    // Top view - simple ring shape with smooth circles
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Smooth outer circle
            cylinder(h = text_height, d = 2.5, $fn = 32);  // Smooth inner hole
        }
    }
    
    // Side view - thin rectangular profile
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([0.75, 4, text_height]);
    }
}

module sae_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    // Top view - simple ring shape with smooth circles (same as standard)
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Smooth outer circle
            cylinder(h = text_height, d = 2.5, $fn = 32);  // Smooth inner hole
        }
    }
    
    // Side view - thicker rectangular profile for SAE
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([1.5, 4, text_height]);  // 2x thickness compared to standard washer
    }
}

module lock_washer_icon(y_pos) {
    z_pos = label_thickness;
    center_x = 0;
    
    translate([center_x - 1, y_pos, z_pos]) {
        difference() {
            cylinder(h = text_height, d = 4, $fn = 32);  // Smooth outer circle
            cylinder(h = text_height, d = 2.5, $fn = 32);  // Smooth inner hole
            translate([0, -0.3, 0]) cube([4, 0.6, text_height]);  // Gap for lock/spring
        }
    }
    
    translate([center_x + 1.5, y_pos - 2, z_pos]) {
        cube([0.75, 4, text_height]);
    }
}

// Debug: If nothing else renders, show this test label
// Comment out these lines once main code is working
if (false) {  // Change to true if you need to test
    echo("Creating debug test label...");
    color("red") cube([35.8, 11.7, 0.65]);
    translate([0, 0, 0.65]) {
        color("white") linear_extrude(0.3) {
            text("V96 TEST", size = 3.5, halign = "center");
        }
    }
}
