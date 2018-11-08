$fn = 60;

module arrow ( edge, depth, zoom ) {
    a = edge/zoom;
    h = sqrt(3)*a/2;
    linear_extrude(depth, scale=zoom)
    polygon([[-h/3,-a/2], [-h/3, a/2], [h-h/3, 0]]);
}
module prism ( x, y, z_min, pitch, miter) {
    h_cent = z_min-miter + (x-2*miter)*pitch/2;
    hull()
    for ( a=[-x/2+miter, x/2-miter] )for ( b=[-y/2+miter, y/2-miter] ) {
        h = z_min + (a+(x/2-miter))*pitch - miter;
        translate([a, b, 0])cylinder(r=miter, h);
        translate([a, b, h])sphere(r=miter);
    }
}

module diag (dist, height, h_offset, radius) {
    for (i=[0:3])
        rotate(i*90+45)translate([dist,-0,-height]) {
            cylinder(d=radius*2,h=height);
        }
}
module dpad (width, height, base, base_width, pitch, miter, ball_size, diag_dist,diag_height,diag_rad) {
    third = width/3;
    
    difference(){
        union(){
            prism(third+4*miter, third, height, 0, miter);
            prism(third, third+4*miter, height, 0, miter);
        }
        translate([0,0,height])
        resize([width/6, width/6, 2*miter])
            sphere(d=1);
    }
    for ( i=[0:3] )
    rotate(i*90)translate([third,0])difference(){
        prism(third, third, height, pitch, miter);
        h_cent = height-miter + (third-2*miter)*pitch/2;
        translate([0,0,h_cent])rotate([0,-atan(pitch)])arrow(width/6, miter, 5);
    }
    
    cylinder(d=base_width, h=base);
    translate([0,0,0])sphere(r=ball_size);
    
    diag(diag_dist,diag_height,base/2,diag_rad);
}

//dpad(21, 6, 1.0, 27, 0.15, 0.75,5.5/2,7.5,0.5,1.5); //v3
//dpad(21, 6.5, 1.0, 27, 0.15, 0.75,5.5/2,7.5,0.5,1.5); //v4
dpad(22, 6.5, 1.0, 27, 0.15, 0.75,5.5/2,7.5,1,1.5); //v5
