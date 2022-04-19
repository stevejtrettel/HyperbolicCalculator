

//----------------------------------------------
//------------------------------------------
//PRODUCING THE IMAGE
//------------------------------------------
//----------------------------------------------









void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    //the vector that will store our final color:
    vec3 color=vec3(0);
    //an overall scaling factor to lighten/darken the image
    float adjustment = 1.;

    // Normalized pixel coordinates
    vec2 z = normalizeCoords( fragCoord );
    vec2 mouse = normalizeCoords(iMouse.xy);

    //rotate slowly around the center of the poincare disk for fun
    float c=cos(iTime/50.);
    float s=sin(iTime/50.);
    mat2 rot = mat2(c,s,-s,c);
   // z=rot*z;

    //check if insidePD
    //if not, turn down the exposure
    if(!insidePD(z)){
        adjustment =0.2;
    }

        //set background color of the disk
        color = darkBlue;

        //move to upper half plane for computations
        z = toHP(z);
        vec2 mouseHP = toHP(mouse);


        //move the origin of PD to mouse location
        if(iMouse.z>0.){
             z = pToOrigin(mouseHP,z);
        }


        //move the origin so it wiggles aound a bit
        vec2 cent = vec2(1.,1.5)+0.25*vec2(sin(iTime/3.),sin(iTime/2.));
       // z=originToP(cent, z);



    //    Triangle T = createTriangle(7,2,3);
//
//        if(inside(z,T)){
//            color=pink;
//        }


//        Horocycle horo = Horocycle(0.,0.);
//
//        if(inside(z, horo)){
//            color=lightGreen;
//        }
//
//

//
//    Geodesic geo = Geodesic(0.,infty);
//        if(dist(z,geo)<0.03){
//            color=darkPurple;
//        }

//

   // Pentagon P = createPentagon(1.3+0.2*sin(iTime),1.3+0.3*sin(iTime/2.));

    float l = asinh(sqrt(3.));
   // Hexagon P = createHexagon(l+0.1*cos(iTime/3.),l+0.1*sin(iTime/2.),l+0.2*sin(iTime));
    Heptagon P = createHeptagon(1.,1.,0.5,1.1);


    if(inside(z,P)){
        color=pink;
    }

    float parity=1.;
    vec2 w = moveInto(z,P,parity);
    float d = dist(w, P);
    if(parity==-1.){
        color=medBlue;
    }
    if(d<0.015){color=lightPurple;}







//        Triangle T = createTriangle(7,2,3);
//
//            if(inside(z,T)){
//                color=pink;
//            }


//
//
//    int word[12];
//
//    word= int[](0,0,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,0,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,3,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,3,2,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,3,2,3,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,3,2,3,2,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,3,2,3,2,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,3,2,3,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,3,2,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,3,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,0,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,0,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,2,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,2,3,2,3,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,2,3,2,3,2,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,3,0,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,3,2,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,3,2,3,2,3,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,3,2,3,2,3,2,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,3,2,3,2,3,2,3,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,1,0,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,1,2,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,1,3,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,2,1,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,2,1,3,2,3,2,3,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](1,2,3,2,1,3,2,3,2,3,2,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,2,3,1,0,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,2,3,1,2,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,2,3,1,3,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,1,2,3,2,1,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,1,2,3,2,1,3,2,3,2,3,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,1,2,3,2,1,3,2,3,2,3,2);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,3,1,3,0,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](3,2,3,1,3,2,3,2,3,2,3,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,3,1,3,0,0,0,0,0,0);
//    colorTriangle(z,T,word,color);
//
//    word= int[](2,3,2,3,1,3,2,3,2,3,2,3);
//    colorTriangle(z,T,word,color);
//
//
//
//


//
//    vec2 w;
//        float d;
//
//
//
//        w = moveInto(z,T);
//        d = dist(w, T.a.bdy);
//        d = min(d, dist(w, T.b.bdy));
//        d = min(d, dist(w, T.c.bdy));
//        if(d<0.015){color=lightPurple;}
//
//        //color the edges of the triangle touching Vertex23
//        w = moveToWedge(z,T.b,T.c);
//        d = min(dist(w,T.b.bdy),dist(w,T.c.bdy));
//        if(d<0.03){color=lightGreen;}
//
//        //color the edges of the triangle touching Vertex12
//        w = moveToWedge(z,T.a,T.b);
//        d = min(dist(w,T.a.bdy),dist(w,T.b.bdy));
//        if(d<0.03){color=lightGreen;}
//
//        //color the edges of the triangle touching Vertex13
//        w = moveToWedge(z,T.a,T.c);
//        d = min(dist(w,T.a.bdy),dist(w,T.c.bdy));
//        if(d<0.03){color=lightGreen;}
//
//
//
//







    //take the computed color and apply the adjustment
    color = adjustment*color;
    //output to the computer screen
    fragColor=vec4(color,1);
}
