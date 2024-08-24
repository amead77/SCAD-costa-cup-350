//replacement lid for a Costa 350ml cup

//set to true if you want the internal cutout, otherwise it'll be a solid lid
c_internal_cutout_wanted = true;

//do you want text on the lid?
c_text_wanted = true;
//text to put on the lid
c_text = "Adam's Cup";
//height of text from the lid
c_text_z = 1.0;
//size of the text
c_text_size = 8.0;
//set to true if you want the text embossed, otherwise it'll be recessed
c_text_embossed = true;


//don't change these below unless you want a different size lid
runlevel = 3;
$fn = 192;
c_top_dia = 79.0;
c_top_lip_z = 4.0;
c_internal_dia = 72.76;
c_internal_z = 16.0;
c_oring_outer_dia = c_internal_dia;
c_oring_internal_dia = 70.0;
c_oring_z = 3.5;
c_oring_z_offset = 3.5;
//this and the next line are for the internal cutout, by setting top to less than bottom the cutout will be a cone shape for strength and easier cleaning
c_internal_cutout_dia_bottom = 60.0; 
c_internal_cutout_dia_top = 50.0;
c_internal_cutout_z = c_internal_z-0.5;


module top_lip() {
    translate([0, 0, 0]) {
        cylinder(h = c_top_lip_z, d = c_top_dia, center = false);
    };
};

module internal_outer() {
    translate([0, 0, c_top_lip_z]) {
        cylinder(h = c_internal_z, d = c_internal_dia, center = false);
    };
};

module exterior() {
    union() {
        top_lip();
        internal_outer();
    };
};

module o_ring() {
    translate([0, 0, (c_top_lip_z+c_internal_z)-(c_oring_z_offset+c_oring_z)]) {
        difference() {
            cylinder(h = c_oring_z, d = c_oring_outer_dia,center = false);
            cylinder(h = c_oring_z, d = c_oring_internal_dia,center = false);
        };
    };
};

module internal_cutout() {
    translate([0, 0, (c_top_lip_z+c_internal_z)-c_internal_cutout_z]) {
        cylinder(h = c_internal_cutout_z, d1 = c_internal_cutout_dia_top, d2 = c_internal_cutout_dia_bottom, center = false);
    };
};


module thetext() {
    if (c_text_embossed == false) {
        translate([0, 0, 0]) {
            linear_extrude(height = c_text_z) {
                text(c_text, size = c_text_size, font = "Arial:style=Bold", halign = "center", valign = "center");
            };
        };
    } else {
        translate([0, 0, -c_text_z]) {
            linear_extrude(height = c_text_z) {
                text(c_text, size = c_text_size, font = "Arial:style=Bold", halign = "center", valign = "center");
            };
        };
    };
};


if (runlevel == 1) {
    exterior();
};

if (runlevel == 2) {
    o_ring();
};

if (runlevel == 3) {
    //render() {
        union() {
            difference() {
                exterior();
                o_ring();
                if (c_internal_cutout_wanted) {                    
                    internal_cutout();
                };
                if ((c_text_embossed==false) && (c_text_wanted)) {
                    mirror([1, 0, 0]) {
                        color("red") {
                            thetext();
                        };
                    };
                };
            };
            if ((c_text_embossed) && (c_text_wanted)) {
                mirror([1, 0, 0]) {
                    color("red") {
                        thetext();
                    };
                };
            };
        };
    //};
};

if (runlevel == 4) {
    render() {
        internal_cutout();
    };
};

if (runlevel == 5) {
    render() {
        thetext();
    };
};

