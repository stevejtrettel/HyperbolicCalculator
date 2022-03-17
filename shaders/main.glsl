

//----------------------------------------------
//------------------------------------------
//PRODUCING THE IMAGE
//------------------------------------------
//----------------------------------------------


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    //setting up a geodesic triangle:

    //vertical geodesic
    Geodesic side1 = Geodesic(0.,infty);
    HalfSpace h1 = HalfSpace(side1,1.);


    //unit circle
    Geodesic side2 = Geodesic(-1.,1.);
    HalfSpace h2 = HalfSpace(side2,1.);


    //annoying one to make angles pi/P and pi/Q
    float ang = cos(PI/Q)/sin(PI/P);
    float h=exp(acosh(ang));
    float side = h/tan(PI/P);
    float rad = h/sin(PI/P);

    float end1=-side-rad;
    float end2=-side+rad;


    Geodesic side3 = Geodesic(end1,end2);
    HalfSpace h3 = HalfSpace(side3,-1.);

    Triangle T = Triangle(h1,h2,h3);





    //the vector that will store our final color:
    vec3 color=vec3(0);


    // Normalized pixel coordinates
    vec2 z = normalizeCoords( fragCoord );

    //check if insidePD
    if(insidePD(z)){

        //set background color of the disk
        color = darkBlue;

        //move to upper half plane for computations
        z = mouseTransform(z);
        z = toUH(z);

        //color the triangle blue
        if(inside(z,T)){
            color=pink;
        }


        vec2 w;
        float d;



        w = moveInto(z,T);
        d = dist(w, h1.bdy);
        d = min(d, dist(w, h2.bdy));
        d = min(d, dist(w, h3.bdy));
        if(d<0.03){color=lightPurple;}

        //color the edges of the triangle touching Vertex23
        w = moveToWedge(z,h2,h3);
        d = min(dist(w,h2.bdy),dist(w,h3.bdy));
        if(d<0.03){color=lightGreen;}

        //color the edges of the triangle touching Vertex12
        w = moveToWedge(z,h1,h2);
        d = min(dist(w,h1.bdy),dist(w,h2.bdy));
        if(d<0.03){color=lightGreen;}

        //color the edges of the triangle touching Vertex13
        w = moveToWedge(z,h1,h3);
        d = min(dist(w,h1.bdy),dist(w,h3.bdy));
        if(d<0.03){color=lightGreen;}


    }

    fragColor=vec4(color,1);
}
