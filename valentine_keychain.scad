text_var = "I LOVE YOU";
add_loop = true;

base_size = 2;

font = "Arial:style=Bold";
font_size = 10;
avg_char_width = font_size * 0.99;

text_width = len(text_var) * avg_char_width;
heart_ratio = 1.0;
heart_size = (text_width / 4) * heart_ratio;
keychain_loop_size = 20;
keychain_loop_thickness = 4;

$fn = 100;

module heart_sub_component(radius) {
    rotated_angle = 45;
    diameter = radius * 2;

    translate([-radius * cos(rotated_angle), 0, 0]) 
        rotate(-rotated_angle) union() {
            circle(radius);
            translate([0, -radius, 0]) 
                square(diameter);
        }
}

module heart(radius) {
    center_offset_y = 1.5 * radius * sin(45) - 0.5 * radius;

    translate([0, center_offset_y, 0]) union() {
        heart_sub_component(radius);
        mirror([1, 0, 0]) heart_sub_component(radius);
    }
}

module keychain_loop(size, thickness) {
    inner_size = size - 2 * thickness;
    
    difference() {
        circle(d=size/2, $fn=100);
        translate([0, 0, 1])
            circle(d=inner_size/2, $fn=100);
    }
}

union() {
    intersection() {
        rotate([90, 0, 90])
            translate([0, base_size - 0.1, -(text_width/2)])
               linear_extrude(height = text_width)
                    text(text_var, size = font_size, font = font, halign = "center", valign = "baseline");

        rotate([0, 0, 90])
            linear_extrude(height = font_size + base_size)
                heart(heart_size);
    }

    rotate([0, 0, 90])
        linear_extrude(height =  base_size)
            heart(heart_size);
    
    if(add_loop) {
        translate([-heart_size * 1.4, 0, 0])
            linear_extrude(height = base_size)
                keychain_loop(keychain_loop_size, keychain_loop_thickness);
    }
}