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


    //HalfSpace c = HalfSpace(Geodesic((cosh(B)-1.)/sinh(B),(cosh(B)+1.)/sinh(B)),1.);



    //below the circle at height A above unit circle
    HalfSpace e = HalfSpace(Geodesic(exp(A),-exp(A)),-1.);





    //this final circle is the result of an annoying computation
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

