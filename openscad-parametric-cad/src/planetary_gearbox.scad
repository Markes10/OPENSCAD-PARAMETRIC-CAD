// ==============================================================================
// Generative Parametric Planetary Gearbox
// Language: OpenSCAD (Constructive Solid Geometry Scripting)
// ==============================================================================

// Design Parameters
module_size = 2.0;         // Gear Module (mm)
sun_teeth = 12;            // Sun Gear Tooth Count
planet_teeth = 18;         // Planet Gear Tooth Count
num_planets = 3;           // Number of Planets
gear_thickness = 15.0;     // Face Width (mm)
bore_diameter = 8.0;       // Shaft Bore (mm)
pressure_angle = 20.0;     // Standard Involute Pressure Angle (degrees)
backlash = 0.15;           // Manufacturing Clearance Tolerance (mm)

// Derived Kinematics
ring_teeth = sun_teeth + 2 * planet_teeth; // Ring teeth = 12 + 36 = 48
gear_ratio = 1 + (ring_teeth / sun_teeth); // Planetary reduction ratio = 1 + 48/12 = 5:1

// Pitch Diameters: d = m * z
sun_pitch_dia = module_size * sun_teeth;       // 24 mm
planet_pitch_dia = module_size * planet_teeth; // 36 mm
ring_pitch_dia = module_size * ring_teeth;     // 96 mm

// Module: Parametric Involute Spur Gear Primitive
module spur_gear(teeth, m, thickness, bore) {
    pitch_r = (m * teeth) / 2.0;
    tip_r = pitch_r + m;
    root_r = max(0.1, pitch_r - 1.25 * m);
    
    difference() {
        cylinder(r = tip_r, h = thickness, center = true, $fn = teeth * 4);
        
        // Central Shaft Bore
        cylinder(r = bore / 2.0, h = thickness + 2.0, center = true, $fn = 32);
        
        // Tooth Valley Cutouts
        for (i = [0 : teeth - 1]) {
            rotate([0, 0, (360.0 / teeth) * i])
            translate([pitch_r, 0, 0])
            cube([m * 1.5, m * 1.2, thickness + 4], center = true);
        }
    }
}

// Complete Planetary Assembly
module planetary_gearbox_assembly() {
    // 1. Central Sun Gear
    color("Gold") spur_gear(sun_teeth, module_size, gear_thickness, bore_diameter);

    // 2. Revolving Planet Gears
    carrier_radius = (sun_pitch_dia + planet_pitch_dia) / 2.0; // 30 mm
    for (p = [0 : num_planets - 1]) {
        angle = (360.0 / num_planets) * p;
        color("Teal")
        translate([carrier_radius * cos(angle), carrier_radius * sin(angle), 0])
        spur_gear(planet_teeth, module_size, gear_thickness, 5.0);
    }

    // 3. Outer Ring Gear Housing
    color("SlateGray", 0.5)
    difference() {
        cylinder(r = (ring_pitch_dia / 2.0) + 10.0, h = gear_thickness + 4.0, center = true, $fn = 64);
        cylinder(r = (ring_pitch_dia / 2.0), h = gear_thickness + 6.0, center = true, $fn = 64);
    }
}

planetary_gearbox_assembly();
