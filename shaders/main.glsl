

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

    //check if insidePD
    //if not, turn down the exposure
    if(!insidePD(z)){
        adjustment =0.2;
    }

        //set background color of the disk
        color = darkBlue;

        //move to upper half plane for computations
        z = mouseTransform(z);
        z = toUH(z);







    //Triangle T = createTriangle(7,2,3);

    HalfSpace hs1 = HalfSpace(Geodesic(0.,infty),1.);
    HalfSpace hs2 = HalfSpace(Geodesic(0.5,infty),-1.);
    HalfSpace hs3 = HalfSpace(Geodesic(-1.,1.),-1.);
    Triangle T = Triangle(hs1, hs2, hs3);

        if(inside(z,T)){
            color=pink;
        }


        Horocycle horo = Horocycle(0.,0.);

        if(inside(z, horo)){
            color=lightGreen;
        }


        Geodesic geo = Geodesic(-1.,2.);
        if(dist(z,geo)<0.03){
            color=darkPurple;
        }



//        vec2 w;
//        float d;
//            w = moveInto(z,T);
//            d = dist(w, T.a.bdy);
//            d = min(d, dist(w, T.b.bdy));
//            d = min(d, dist(w, T.c.bdy));
//            if(d<0.015){color=lightPurple;}









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









    //take the computed color and apply the adjustment
    color = adjustment*color;
    //output to the computer screen
    fragColor=vec4(color,1);
}
