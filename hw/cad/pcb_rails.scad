

pcb_width = 85.86 + 0.4;
pcb_thickness = 1.6+0.2;
pcb_above_ground = 12.6; 

pcb_rail_thickness = 1.6+0.8+0.8+0.1;
pcb_rail_depth = 0.5;

albase_length = 162;
box_width = 95-0.5;

flange_width = 20;
flange_th = 3.5;
mounting_holes_distance = 3*10.16;

M3_screw_diameter = 3.25;
M3_nut_diameter = 6.4;


module pcb_edge(){
    difference(){
        translate([0, 0, 1]) cube([136.6+1, 1.6+0.75+0.75, 2], center=true);
        translate([-1, 0, 1+0.4]) cube([136.6+1, 1.65, 2], center=true);
        translate([0, 0.8+0.75, 0]) rotate([0, 90, 0]) cylinder(d=1, h=150, center=true, $fn=4);
        translate([0, -0.8-0.75, 0]) rotate([0, 90, 0]) cylinder(d=1, h=150, center=true, $fn=4);
        translate([136.6/2+0.75, 0.8+0.75, 0.8]) rotate([0, 0, 0]) cylinder(d=2, h=5, center=true, $fn=4);
        translate([136.6/2+0.75, -0.8-0.75, 0.8]) rotate([0, 0, 0]) cylinder(d=2, h=5, center=true, $fn=4);
        translate([136.6/2+0.75, -0.8-0.75, -1]) rotate([90, 0, 0]) rotate([0,0,-15]) cylinder(d=5, h=10, center=true, $fn=4);
    }

}

//pcb_edge();

module rail(){
    
    difference(){
        union(){
            translate([box_width/2-6, -albase_length/2, 0]) cube([6, albase_length, pcb_above_ground+pcb_thickness*2]);
            translate([box_width/2-flange_width, -(albase_length)/2, 0]) cube([flange_width, 60, flange_th]);
            translate([box_width/2-flange_width, -(albase_length)/2, 0]) cube([flange_width, 20, pcb_above_ground]);
            translate([box_width/2-8, -(albase_length)/2, 3.5]) rotate([0, 45, 0]) cube([4, albase_length, 4]);
            
            translate([box_width/2-10, -albase_length/2, 0]) cube([10, albase_length, flange_th]);
            
         
        
        }
        
        for(m=[0, 1]) mirror([0, m, 0]) {
            translate([pcb_width/2, -albase_length/2+15, 3]) rotate([90, 0, 0]) cylinder(d=M3_screw_diameter, h=20, $fn=60);
            
            hull(){
                translate([pcb_width/2, -albase_length/2+5, 3]) rotate([90, 0, 0]) cylinder(d=M3_nut_diameter, h=3, $fn=6);
                translate([pcb_width/2, -albase_length/2+5, -3]) rotate([90, 0, 0]) cylinder(d=M3_nut_diameter, h=3, $fn=6);
            }
        }
    
    translate([0, -(albase_length+1)/2, pcb_above_ground])
        cube([pcb_width/2, albase_length+1, pcb_thickness]);
    translate([0, -(albase_length-40)/2, pcb_above_ground-(pcb_rail_thickness-pcb_thickness)/2])
        cube([pcb_width/2+pcb_rail_depth, albase_length, pcb_rail_thickness]);
    
    for(y = [5, 0], x=[10.16]) translate([mounting_holes_distance+x, (y+0.5)*10.16, -0.1]) {
        cylinder(d = M3_screw_diameter, h=5, $fn=30);
        translate([0, 0, 3]) rotate([0, 0, 30]) cylinder(d=6.5, h=7, $fn=60);
        }
        
    for(y = [-7], x=[10.16]) translate([mounting_holes_distance+x, (y+0.5)*10.16, -0.1]) {
        cylinder(d = M3_screw_diameter, h=20, $fn=30);
        translate([0, 0, pcb_above_ground+0.1]) cylinder(d = 6.5, h=20, $fn=30);
        }
    
    for(y = [-3], x=[0]) translate([mounting_holes_distance+x, (y+0.5)*10.16, -0.1]) {
        cylinder(d = M3_screw_diameter, h=30, $fn=30);
        translate([0, 0, 3]) rotate([0, 0, 30]) cylinder(d=6.5, h=3, $fn=60);
        }
        for(y = [-8], x=[0]) translate([mounting_holes_distance+x, (y+0.5)*10.16, -0.1]) {
        cylinder(d = M3_screw_diameter, h=30, $fn=30);
        //translate([0, 0, 3]) rotate([0, 0, 30]) cylinder(d=6.5, h=3, $fn=60);
        }
    }
    

}



//rail();
//mirror([1, 0, 0]) rail();


batdat_case_length = 136;
batdat_case_width = 82;
batdat_case_thickness = 7;

screw_shift = 12.0-10.16/2-4.83;

sn_view_position_x = 10.16*6-screw_shift+3.27;

module bottom_case(){

    difference(){
        translate([0, 0, batdat_case_thickness/2])
            cube([batdat_case_length, batdat_case_width, batdat_case_thickness], center=true);
    
        
        for(x=[-1, 1], y=[-1, 1])
            translate([x*10.16*6-screw_shift, y*10.16*3.5+0, -0.1]) {
            translate([0, 0, 3.2])
                cylinder(d=M3_screw_diameter, h=10, $fn=50);
            cylinder(d=7, h=3, $fn=50);
        }
        
        
        // pro senzory 
        translate([45, batdat_case_width/2, batdat_case_thickness]) cube([13, 10, 5], center=true);
            
        
        translate([0, 3, 0.3]) intersection(){
        for(x=[-8:7], y=[-4:3]) translate([x*7, y*8+(x%2==0? 4:0), 0]) cylinder(d=7.5, h=10, $fn=6);
        
        
        }
        
        
        
        // srazeni spodni hrany
        for(y=[-1, 1])
            translate([0, y/2*batdat_case_width, 0])
                rotate([0, 90, 0]) 
                    cylinder(h=batdat_case_length, r=2, center=true, $fn=4);

        // hlavni odebrani vyplne
        difference(){
            union(){
                translate([0, 0, 5+0.75]) 
                    cube([130, 77, 10], center=true);
                translate([-10, 0, 2.5+batdat_case_thickness-5]) 
                    cube([130, 62, 5], center=true);
            }
            
        
        // Okenko pro SN
        //translate([sn_view_position_x, 0, 0]) cube([8+1.4, 45+1.4, 20], center=true);
            
            
            
        for(x=[-1, 1], y=[-1, 1]) translate([x*10.16*6-screw_shift, y*10.16*3.5+0, -0.1]) {
            cylinder(d=8, h=10, $fn=50);
            cylinder(d1=12,d2=8, h=3, $fn=50);
        }
            
        }
        
        // Okenko pro SN
        //translate([sn_view_position_x, 0, 0]) cube([8, 45, 20], center=true);
            
    
    
    }
    
    
}


//bottom_case();




box_outer_w = 103+0.5;
box_outer_h = 53+0.5;
box_pcb_shift = 10;



module front_cover_empty(){



    difference(){
        union(){
            minkowski(){
                sphere(d=10, $fn=8);
                translate([0, 0, 5]) cube([box_outer_w+5-10, box_outer_h+5-10, 4], center=true);
            }
    
        }
        
    
    translate([0, 0, 5+5]) cube([200, 200, 10], center=true);
        
    minkowski(){
        cylinder(d=8, h=10, $fn=30);
        cube([box_outer_w-8+0.6, box_outer_h-8+0.6, .1], center=true);
    }
    }
}


leds_positions_top = [25.07, 22.3, 19.52, 1.3, -1.46, -4.25, -7, -9.78, -12.53, -15.3, -18.1, -23.2, -27.1];
leds_positions_bottom = [-9.78, -15.3];
leds_button = [7.4, 14.75];

module front_cover(){

    difference(){
        front_cover_empty();
        
        
        for(x=leds_positions_top) translate([x, 1.6/2+0.8, 0]) scale([1, 1, 1]) cylinder(d=2,h=20, $fn=30, center=true);
        for(x=leds_positions_bottom) translate([x, -1.6/2-0.8, 0]) scale([1, 1, 1]) cylinder(d=2,h=20, $fn=30, center=true);
        for(x=leds_button) translate([x, 1.6/2+1.75]) cylinder(d=2.2,h=20, $fn=30, center=true);
     
  
  // Otvory pro srouby na prisroubovani celicka
    translate([pcb_width/2, -pcb_above_ground+3, 0]) cylinder(d=M3_screw_diameter, h=10, center=true, $fn=60);
    translate([-pcb_width/2, -pcb_above_ground+3, 0]) cylinder(d=M3_screw_diameter, h=10, center=true, $fn=60);

    }

        translate([0, 1.6/2, 0]) difference(){
            translate([0, 2.5, 4]) cube([80.7, 5, 8], center=true);
            difference(){
                translate([0, 0.5, 2]) cube([29*2, 1.5, 4], center=true);
                translate([10.5, 0.5, 2]) cube([15, 1.5, 4], center=true);
            }
            for(x=leds_button) translate([x, 1.75]) {
                cylinder(d=2.2,h=20, $fn=30, center=true);
                translate([0, 0, 4]) cylinder(d=7,h=20, $fn=30);
             }   
            for(x=[0.5, -0.5])  translate([x*10.16*7, 0, 4.9]) rotate([90, 0, 0]) cylinder(d=M3_screw_diameter, h=10, center=true, $fn=30);
            
   
    }
}


module rear_cover(){

    difference(){
        front_cover_empty();
        
        
  // Otvory pro srouby na prisroubovani celicka
    translate([pcb_width/2, -pcb_above_ground+3, 0]) cylinder(d=M3_screw_diameter, h=10, center=true, $fn=60);
    translate([-pcb_width/2, -pcb_above_ground+3, 0]) cylinder(d=M3_screw_diameter, h=10, center=true, $fn=60);

     
    for(x=[0.5, -0.5], y=[-0.5, 0.5]) translate([x*95, y*45.47, -1.7]) {
        cylinder(d=4.2, h = 10, $fn=60);
        cylinder(d1=5.85, d2=4.2, h = 1, $fn=60);
    }

    
    }
    
    

        translate([0, 1.6/2, 0]) difference(){
            translate([0, 2.5, 4]) cube([70.6, 5, 8], center=true);
            translate([0, 2.5, 4]) cube([70.6-10.16*2, 5+1, 8+1], center=true);
           
            for(x=[0.5, -0.5])  translate([x*10.16*6, 0, 4.9]) rotate([90, 0, 0]) cylinder(d=M3_screw_diameter, h=10, center=true, $fn=30);
            
   
    }
}

rear_cover();