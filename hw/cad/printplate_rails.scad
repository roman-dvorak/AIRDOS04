use<pcb_rails.scad>;


rotate([0, 90, 0]) rail();
translate([-5, 0, 0]) mirror([1, 0, 0]) rotate([0, 90, 0]) rail();