//definitions for hyperbolic polygons, squares, etc
//requries geodesics.glsl (needs half spaces, etc)



//------------------------------------------
//Triangles
//------------------------------------------



//a triangle is the intersection of three half spaces
//we will call these a, b, and c
struct Triangle{
    HalfSpace a;
    HalfSpace b;
    HalfSpace c;
};




bool inside(vec2 z, Triangle T){
    //check if you are inside all three half-spaces
    return inside(z,T.a)&&inside(z,T.b)&&inside(z,T.c);
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Triangle T){
    z = reflectIn(z, T.a);
    z = reflectIn(z, T.b);
    z = reflectIn(z, T.c);
    return z;
}


//iteratively reflect in the triangle until you end up
//in the fundamental domain
vec2 moveInto(vec2 z, Triangle T){

    for(int i=0;i<50;i++){
        z=reflectIn(z,T);
        if(inside(z,T)){
            break;
        }
    }

    return z;

}

float dist( vec2 z, Triangle T){
    float d;
    d = dist(z, T.a.bdy);
    d = min(d, dist(z, T.b.bdy));
    d = min(d, dist(z, T.c.bdy));
    return d;
}



Triangle createTriangle(int p, int q, int r){

    float P = float(p);
    float Q = float(q);
    float R = float(r);
//    float P = float(p);
//    float Q = float(q);
//    float R = float(r);


    //setting up a geodesic triangle:

    //vertical geodesic
    Geodesic side1 = Geodesic(0.,infty);
    HalfSpace h1 = HalfSpace(side1,1.);

    //side making angle Pi/Q with the vertical, intersecting at i
    float ang = tan(PI/(2.*Q));
    Geodesic side2 = Geodesic(-ang,1./ang);
    HalfSpace h2 = HalfSpace(side2, 1.);

    //side making angle PI/R with vertical, intersecting at e^a*i
    float num  = cos(PI/P) + cos(PI/Q) * cos(PI/R);
    float denom = sin(PI/Q) * sin(PI/R);
    //cosha is from the hyperbolic law of cosines
    float cosha = num/denom;

    //since acosh(z)=log(z+sqrt(z^2-1)), the following is exp(a)= exp(acosh(cosh(a))
    float x = cosha + sqrt(cosha*cosha-1.);

    //angle here is tanPi/r
    ang = tan(PI/(2.*R));
    Geodesic side3 = Geodesic(-x/ang,x*ang);
    HalfSpace h3 = HalfSpace(side3, -1.);


    Triangle T=Triangle(h1,h2,h3);

    return T;
}











vec2 reflectInSide(vec2 z, Triangle T, int side){
    switch(side){
        case 0: return z;
        case 1: return reflectIn(z,T.a.bdy);
        case 2: return reflectIn(z,T.b.bdy);
        case 3: return reflectIn(z,T.c.bdy);
    }
    return z;
}

vec2 computeWord(vec2 z, Triangle T, int word[12]){
    for(int i=0; i<12; i++){
        z=reflectInSide(z,T,word[i]);
    }

    return z;
}


vec2 computeWordInverse(vec2 z, Triangle T, int word[12]){
    for(int i=0; i<12; i++){
        z=reflectInSide(z,T,word[11-i]);
    }

    return z;
}



void colorTriangle(vec2 z, Triangle T, int[12] word, inout vec3 color){
    vec2 res = computeWordInverse(z,T,word);
    if(inside(res,T)){
        color=pink;
    }
}

void colorTriangleInverse(vec2 z, Triangle T, int[12] word, inout vec3 color){
    vec2 res = computeWordInverse(z,T,word);
    if(inside(res,T)){
        color=vec3(1,1,0);
    }
}









//------------------------------------------
//Right Angled Pentagons
//------------------------------------------

//a  right angled pentagon is the intersection of 5 orthognal half spaces
//we will call these a, b, c, d, and e
struct Pentagon{
    HalfSpace a;
    HalfSpace b;
    HalfSpace c;
    HalfSpace d;
    HalfSpace e;
};




bool inside(vec2 z, Pentagon P){
    //check if you are inside all three half-spaces
    return inside(z,P.a)&&inside(z,P.b)&&inside(z,P.c)&&inside(z,P.d)&&inside(z,P.e);
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Pentagon P){
    z = reflectIn(z, P.a);
    z = reflectIn(z, P.b);
    z = reflectIn(z, P.c);
    z = reflectIn(z, P.d);
    z = reflectIn(z, P.e);
    return z;
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Pentagon P, inout float parity){
    z = reflectIn(z, P.a, parity);
    z = reflectIn(z, P.b, parity);
    z = reflectIn(z, P.c, parity);
    z = reflectIn(z, P.d, parity);
    z = reflectIn(z, P.e, parity);
    return z;
}



//iteratively reflect in the triangle until you end up
//in the fundamental domain
vec2 moveInto(vec2 z, Pentagon P){

    for(int i=0;i<50;i++){
        z=reflectIn(z,P);
        if(inside(z,P)){
            break;
        }
    }

    return z;

}


//iteratively reflect until you end up in the domain
//report the parity of the number of flips:
vec2 moveInto(vec2 z, Pentagon P, out float parity){

    parity=1.;

    for(int i=0;i<50;i++){
        z=reflectIn(z,P,parity);
        if(inside(z,P)){
            break;
        }
    }

    return z;

}



float dist( vec2 z, Pentagon P){
    float d;
    d = dist(z, P.a.bdy);
    d = min(d, dist(z, P.b.bdy));
    d = min(d, dist(z, P.c.bdy));
    d = min(d, dist(z, P.d.bdy));
    d = min(d, dist(z, P.e.bdy));
    return d;
}



Pentagon createPentagon(float A, float B){

    //to the right of the vertical line
    HalfSpace a = HalfSpace(Geodesic(0.,infty),1.);

    //above the unit circle
    HalfSpace b = HalfSpace(Geodesic(-1.,1.),1.);

    //above the circle which is translate of vertical line along unit circle by dist B
    HalfSpace c = HalfSpace(Geodesic(tanh(B/2.),1./tanh(B/2.)),1.);


    //below the circle at height A above unit circle
    HalfSpace e = HalfSpace(Geodesic(exp(A),-exp(A)),-1.);



    //this final circle is the translate of the vertical geodesic along unit circle by E, then dilation z->exp(A)z
    //the computaiton is annoying because we need tanh(E/2) and coth(E/2) for the endpoints; but need them in terms of A and B

    float cA = cosh(A);
    float sA = sinh(A);
    float cB = cosh(B);
    float sB = sinh(B);

    float cD = sA*sB;
    float sD = sqrt(cD*cD-1.);

    //coshE and sinhE:
    float cE = sB*cA/sD;
    float sE = cB/sD;

    //tanh(E/2):
    float tanhE2 = sE/(1.+cE);
    float eA = exp(A);

    float end1 = eA*tanhE2;
    float end2 = eA/tanhE2;

    //above this circle
    HalfSpace d = HalfSpace(Geodesic(end1,end2),1.);

    Pentagon P = Pentagon(a,b,c,d,e);
    return P;
}















//------------------------------------------
//Right Angled Hexagons
//------------------------------------------

//a  right angled pentagon is the intersection of 5 orthognal half spaces
//we will call these a, b, c, d, and e
struct Hexagon{
    HalfSpace a;
    HalfSpace b;
    HalfSpace c;
    HalfSpace d;
    HalfSpace e;
    HalfSpace f;
};




bool inside(vec2 z, Hexagon H){
    //check if you are inside all six half-spaces
    return inside(z,H.a)&&inside(z,H.b)&&inside(z,H.c)&&inside(z,H.d)&&inside(z,H.e)&&inside(z,H.f);
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Hexagon H){
    z = reflectIn(z, H.a);
    z = reflectIn(z, H.b);
    z = reflectIn(z, H.c);
    z = reflectIn(z, H.d);
    z = reflectIn(z, H.e);
    z = reflectIn(z, H.f);
    return z;
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Hexagon H, inout float parity){
    z = reflectIn(z, H.a, parity);
    z = reflectIn(z, H.b, parity);
    z = reflectIn(z, H.c, parity);
    z = reflectIn(z, H.d, parity);
    z = reflectIn(z, H.e, parity);
    z = reflectIn(z, H.f, parity);
    return z;
}


//iteratively reflect in the triangle until you end up
//in the fundamental domain
vec2 moveInto(vec2 z, Hexagon H){

    for(int i=0;i<50;i++){
        z=reflectIn(z,H);
        if(inside(z,H)){
            break;
        }
    }

    return z;

}


//iteratively reflect until you end up in the domain
//report the parity of the number of flips:
vec2 moveInto(vec2 z, Hexagon H, out float parity){

    parity=1.;

    for(int i=0;i<50;i++){
        z=reflectIn(z,H,parity);
        if(inside(z,H)){
            break;
        }
    }

    return z;

}



float dist( vec2 z, Hexagon H){
    float d;
    d = dist(z, H.a.bdy);
    d = min(d, dist(z, H.b.bdy));
    d = min(d, dist(z, H.c.bdy));
    d = min(d, dist(z, H.d.bdy));
    d = min(d, dist(z, H.e.bdy));
    d = min(d, dist(z, H.f.bdy));
    return d;
}



Hexagon createHexagon(float x, float y, float z){

    //sinh and cosh of the original side lengths
    float cx = cosh(x);
    float cy = cosh(y);
    float cz = cosh(z);

    float sx = sinh(x);
    float sy = sinh(y);
    float sz = sinh(z);

    //compute the opposing side lengths
    float cX = (cx+cy*cz)/(sy*sz);
    float cY = (cy+cx*cz)/(sx*sz);
    float cZ = (cz+cx*cy)/(sx*sy);

    float X = acosh(cX);
    float Y = acosh(cY);
    float Z = acosh(cZ);

    float sX = sinh(X);
    float sY = sinh(Y);
    float sZ = sinh(Z);


    //start computing the edges:

    //the red side is vertical:
    HalfSpace a = HalfSpace(Geodesic(0.,infty),1.);

    //the yellow side is the unti circle:
    HalfSpace b = HalfSpace(Geodesic(-1.,1.),1.);

    //the purple side is the big circle at the top
    HalfSpace f = HalfSpace(Geodesic(exp(Y),-exp(Y)),-1.);

    //the green side is translated along the yellow by distance x
    HalfSpace c = HalfSpace(Geodesic(tanh(x/2.),1./tanh(x/2.)),1.);

    //the indigo side is translated along the purple by distance z
    HalfSpace e = HalfSpace(Geodesic(exp(Y)*tanh(z/2.),exp(Y)/tanh(z/2.)),1.);

   //to compute the final blue side, we need the length of the common perpendicular d
    float cD = sx*sZ;
    float D = acosh(cD);
    float sD = sinh(D);

    //we also need the height h
    float sh = cZ/sD;
    float h = asinh(sh);

    HalfSpace d = HalfSpace(Geodesic(exp(h)*tanh(D/2.),exp(h)/tanh(D/2.)),1.);

    //finally we have the complete hexagon
    Hexagon H = Hexagon(a,b,c,d,e,f);
    return H;
}









//------------------------------------------
//Right Angled Heptagon
//------------------------------------------

//a  right angled pentagon is the intersection of 5 orthognal half spaces
//we will call these a, b, c, d, and e
struct Heptagon{
    HalfSpace a;
    HalfSpace b;
    HalfSpace c;
    HalfSpace d;
    HalfSpace e;
    HalfSpace f;
    HalfSpace g;
};




bool inside(vec2 z, Heptagon H){
    //check if you are inside all six half-spaces
    return inside(z,H.a)&&inside(z,H.b)&&inside(z,H.c)&&inside(z,H.d)&&inside(z,H.e)&&inside(z,H.f)&&inside(z,H.g);
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Heptagon H){
    z = reflectIn(z, H.a);
    z = reflectIn(z, H.b);
    z = reflectIn(z, H.c);
    z = reflectIn(z, H.d);
    z = reflectIn(z, H.e);
    z = reflectIn(z, H.f);
    z = reflectIn(z, H.g);
    return z;
}



//reflect in each side of the triangle,
//if the point is on the wrong side of the half space
vec2 reflectIn(vec2 z, Heptagon H, inout float parity){
    z = reflectIn(z, H.a, parity);
    z = reflectIn(z, H.b, parity);
    z = reflectIn(z, H.c, parity);
    z = reflectIn(z, H.d, parity);
    z = reflectIn(z, H.e, parity);
    z = reflectIn(z, H.f, parity);
    z = reflectIn(z, H.g, parity);
    return z;
}


//iteratively reflect in the triangle until you end up
//in the fundamental domain
vec2 moveInto(vec2 z, Heptagon H){

    for(int i=0;i<50;i++){
        z=reflectIn(z,H);
        if(inside(z,H)){
            break;
        }
    }

    return z;

}


//iteratively reflect until you end up in the domain
//report the parity of the number of flips:
vec2 moveInto(vec2 z, Heptagon H, out float parity){

    parity=1.;

    for(int i=0;i<50;i++){
        z=reflectIn(z,H,parity);
        if(inside(z,H)){
            break;
        }
    }

    return z;

}



float dist( vec2 z, Heptagon H){
    float d;
    d = dist(z, H.a.bdy);
    d = min(d, dist(z, H.b.bdy));
    d = min(d, dist(z, H.c.bdy));
    d = min(d, dist(z, H.d.bdy));
    d = min(d, dist(z, H.e.bdy));
    d = min(d, dist(z, H.f.bdy));
    d = min(d, dist(z, H.g.bdy));
    return d;
}



Heptagon createHeptagon(float B, float C, float E, float G){

    //sinh and cosh of the original side lengths
    float cB = cosh(B);
    float cC = cosh(C);
    float cE = cosh(E);
    float cG = cosh(G);

    float sB = sinh(B);
    float sC = sinh(C);
    float sE = sinh(E);
    float sG = sinh(G);

    //compute the side length X of the common perpendicular to A and D:
    float cX = sB*sC;
    float X = acosh(cX);
    float sX = sinh(X);

    //compute the side F, and its sinh/cosh
    float cF = (cG*cE+cX)/sE*sG;
    float F = acosh(cF);
    float sF = sinh(F);


    //compute the two subdividsions h and k of A:
    //then compute the side A itself!
    float h = asinh(sE*sF/sX);
    float k = asinh(cC/sX);
    float A = k+h;
    float cA = cosh(A);
    float sA = sinh(A);


    // compute the two subdivisions u and v of D
    //then compute D itself!
    float u = asinh(sG*sF/sX);
    float v = asinh(cB/sX);
    float D = u+v;
    float cD = cosh(D);
    float sD = sinh(D);




    //start computing the edges:


    //vertical side:
    HalfSpace a = HalfSpace(Geodesic(0.,infty),1.);

    //first two:
    HalfSpace b = HalfSpace(Geodesic(-1.,1.),1.);

    HalfSpace c = HalfSpace(Geodesic(tanh(B/2.),1./tanh(B/2.)),1.);


    //back two:
    HalfSpace f = HalfSpace(Geodesic(exp(A)*tanh(G/2.),exp(A)/tanh(G/2.)),1.);

    HalfSpace g = HalfSpace(Geodesic(-exp(A),exp(A)),-1.);



    //slide vert distance X along perp geodesic (at height k above i):
    HalfSpace d = HalfSpace(Geodesic(exp(k)*tanh(X/2.),exp(k)/tanh(X/2.)),1.);



    //need two new lengths here: Y = perpenicular to {A,E} and its height A2:
    float cY = sF*sG;
    float Y = acosh(cY);
    float sY = sinh(Y);

    //alpha is segment along A from TOP to the seg y:
    float salpha = cF/sY;
    float alpha = asinh(salpha);

    HalfSpace e = HalfSpace(Geodesic(exp(A-alpha)*tanh(Y/2.),exp(A-alpha)/tanh(Y/2.)),1.);


    //finally we have the complete hexagon
    Heptagon H = Heptagon(a,b,c,d,e,f,g);

    return H;
}











//------------------------------------------
//Wedge of 2 half spaces:
//------------------------------------------

vec2 moveToWedge(vec2 z, HalfSpace hs1, HalfSpace hs2){

    for(int i=0; i<int(max(P,Q))+1; i++){
        z=reflectIn(z, hs1);
        z=reflectIn(z, hs2);
        if( inside(z,hs1)&&inside(z,hs2) ){
            break;
        }
    }

    return z;
}

