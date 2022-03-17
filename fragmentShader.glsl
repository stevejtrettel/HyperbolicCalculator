//------------------------------------------
//Useful Constants
//------------------------------------------

float PI = 3.14159;
float sqrt2 = sqrt(2.);
float sqrt3 = sqrt(3.);
vec2 I = vec2(0.,1.);

//floating point infinity:
//the funciton isinf() tests if a value is infinite, returning a boolean
float infty = 1./0.;

float P = 3.;
float Q = 7.;



//------------------------------------------
//Useful Colors
//------------------------------------------

vec3 lightBlue = vec3(170,210,255)/255.;
vec3 medBlue = vec3(120, 170, 250)/255.;
vec3 darkBlue = vec3(110, 155, 240)/255.;

vec3 lightPurple = vec3(170,210,255)/255. + vec3(0.2,0,0);
vec3 medPurple = vec3(120, 170, 250)/255. + vec3(0.3,0,0);
vec3 darkPurple = vec3(110, 155, 240)/255. + vec3(0.3,0,0);

vec3 lightGreen = vec3(149, 245, 181)/255.;

vec3 pink = vec3(255, 117, 133)/255.;


//----------------------------------------------
//------------------------------------------
//SETUP
//------------------------------------------
//----------------------------------------------

//this takes in the pixel coordinates on the screen (fragCoord) and rescales
//them to show the appropriate region of the plane
vec2 normalizeCoords( vec2 fragCoord ){

    // Normalized the pixel coordinates from 0 to 1
    //fragCoord is a vector of integers, giving the pixel on the screen
    //its (0,0) in the top left, increasing down and to the right.
    //iResolution is a uniform giving the total number of pixels across x,y
    //the bottom right corner of the screen has pixel coordinates (iResolution.x, iResolution.y)


    //dividing fragCoord by iResolution results in coordinates running from (0,0) to (1,1)
    vec2 uv =fragCoord/iResolution.xy;

    //translate so coordinates run (-0.5, 0.5)
    uv = uv - vec2(0.5);

    //preserve original aspect ratio
    float aspect = iResolution.y/iResolution.x;
    uv = vec2(1,aspect)*uv;

    //rescale however you like
    uv = 4.*uv;

    return uv;
}






//----------------------------------------------
//------------------------------------------
//COMPLEX NUMBERS
//------------------------------------------
//----------------------------------------------

//points in the hyperbolic plane are represented by vec2(x,y)
//these can be added, subtracted and scalar multiplied by built-in operations
//these can be multiplied and inverted (as complex numbers) using the following


//turn a real number into a complex number
vec2 toC( float x ){
    return vec2(x,0);
}



//complex multiplication
vec2 mult( vec2 z, vec2 w )
{
    float re = z.x*w.x - z.y*w.y;
    float im = z.x*w.y + z.y*w.x;

    vec2 res = vec2(re, im);
    return res;
}


//complex conjugation, negates imaginary party
vec2 conj( vec2 z )
{
    vec2 res = vec2(z.x,-z.y);
    return res;
}


//inverse of the complex number z
vec2 invert( vec2 z )
{
    float mag2 = dot(z,z);
    vec2 res = conj(z)/mag2;
    return res;
}


//compute the quotient z/w
vec2 divide( vec2 z, vec2 w )
{
    return mult(z,invert(w));
}















//----------------------------------------------
//------------------------------------------
//CONVERSIONS BETWEEN MODELS
//------------------------------------------
//----------------------------------------------


//------------------------------------------
//Poincare Disk Model
//------------------------------------------


//check if you are inside the unit disk or not
bool insidePD( vec2 z )
{
    //returns true if the inequality is satisfied, falso otherwise
    return dot(z,z)<1.;
}



//apply the mobius transformation taking a point to UHP
//this is the map z -> (iz+1)/(z+i)
vec2 toUH( vec2 z ){

    vec2 num = z+I;
    vec2 denom = mult(I,z)+toC(1.);
    vec2 res = divide(num,denom);
    return res;
}


//uses mouse position to make a mobius transformation
vec2 mouseTransform(vec2 z){
    if (iMouse.z>0.) {
        vec2 m = normalizeCoords(iMouse.xy);
        // Unit disc inversion
        m /= dot(m,m);
        z -= m;
        float k = (dot(m,m)-1.0)/dot(z,z);
        z *= k;
        z += m;
    }
    return z;
}








//------------------------------------------
//Upper Half Plane Model
//------------------------------------------

//check if you are in the upper half plane or not
bool insideHP( vec2 z )
{
    //returns true if the inequality is satisfied, falso otherwise
    return z.y>0.;
}


//take a point in the upper half plane and map it to the disk
//this is the transformation z -> (z-i)/(z+i)
vec2 toPD(vec2 z){
    vec2 num = z-I;
    vec2 denom = z+I;
    vec2 res = divide(num,denom);
    return res;
}












//----------------------------------------------
//------------------------------------------
//HYPERBOLIC GEOMETRY (in the upper half plane)
//------------------------------------------
//----------------------------------------------



//------------------------------------------
//Isometries
//------------------------------------------

//this is a general mobius transformation applied to points in upper half space
//do the mobius transformation ((a,b),(c,d)).z
vec2 applyMobius(vec4 mob, vec2 z){
    float a=mob.x;
    float b=mob.y;
    float c=mob.z;
    float d=mob.w;

    vec2 num = a*z+toC(b);
    vec2 denom = c*z + toC(d);

    vec2 res = divide(num,denom);

    return res;

}




//------------------------------------------
//Points
//------------------------------------------
// a point is just a vec2, thought of as a complex number;
//no special structure here


//measure the distance to a point
float dist(vec2 z, vec2 p){

    //just directly using distance function in UH
    vec2 rel = z-p;
    float num = dot(rel,rel);
    float denom = 2.*z.y*p.y;
    return acosh(1.+num/denom);

}



//------------------------------------------
//Circles
//------------------------------------------
//a circle has a point for its center, and a float for radius

struct Circle{
    vec2 center;
    float radius;
};


float dist(vec2 z, Circle circ){
    //measure distance from center
    float d = dist(z,circ.center);
    //subtract circles radius
    return abs(d-circ.radius);
}



bool inside(vec2 z, Circle circ){
    //if distance from z to center is less than radius, we're inside
    return dist(z,circ.center)<circ.radius;
}







//------------------------------------------
//Horocycles
//------------------------------------------


//a horocycle is given by its ideal point,
//and an offset: how far the horocycle is from passing through i
struct Horocycle {
    float ideal;
    float offset;
};


float dist(vec2 z, Horocycle horo){

    //if the horocycle is based at infinity:
    if(isinf(horo.ideal)){
        //move by the offset
        z /= exp(horo.offset);
        //measure distance from y=1:
        return abs(z.y-1.);
    }


    //otherwise, compute by conjugating:
    else{

        //find mobius transformation fixing i, taking ideal pt to infinty:
        float d = sqrt(horo.ideal*horo.ideal+1.);
        float c = horo.ideal/d;
        float s = -1./d;
        vec4 mob = vec4(c,-s,s,c);

        //apply this mobius transformation to z:
        z = applyMobius(mob, z);


        //now do the computation from above:
        //move by the offset
        z /= exp(horo.offset);
        //measure distance from y=1:
        return abs(z.y-1.);
    }
}

bool inside(vec2 z, Horocycle horo){

    //if the horocycle is based at infinity:
    if(isinf(horo.ideal)){
        //move by the offset
        z /= exp(horo.offset);
        //true if above y=1;
        return z.y>1.;
    }


    //otherwise, compute by conjugating:
    else{

        //find mobius transformation fixing i, taking ideal pt to infinty:
        float d = sqrt(horo.ideal*horo.ideal+1.);
        float c = horo.ideal/d;
        float s = -1./d;
        vec4 mob = vec4(c,-s,s,c);

        //apply this mobius transformation to z:
        z = applyMobius(mob, z);


        //now do the computation from above:
        //move by the offset
        z /= exp(horo.offset);
        //true if above y=1.;
        return z.y>1.;
    }

}







//------------------------------------------
//Geodesics
//------------------------------------------


//a geodesic is encoded by remembering its two boundary points
//these are real numbers (or the constant infty)
struct Geodesic{
//first endpoint
    float p;
//second endpoint
    float q;
};



//check if a geodesic is a line
bool isLine( Geodesic geo ) {
    return isinf(geo.p)||isinf(geo.q);
}




//check if a geodesic is a line, and return its endpoint
bool isLine( Geodesic geo, out float endpt ) {

    //if p is infinity, q is the real endpoint
    if(isinf(geo.p)){
        endpt = geo.q;
        return true;
    }

    //if q is infinity, p is the real endpoint
    else if ( isinf(geo.q) ){
        endpt = geo.p;
        return true;
    }

    //if neither is infinity, its not a line
    return false;
}





//reflect in the geodesic geo
vec2 reflectIn(vec2 z, Geodesic geo){

    float endpt;

    //if its a line, do one thing
    if(isLine(geo,endpt)){
        z.x -= endpt;
        z.x *= -1.;
        z.x += endpt;
        return z;
    }

    //else, if its a circle do something else
    else{
        float center = (geo.p+geo.q)/2.;
        float radius = abs((geo.p-geo.q))/2.;

        z.x -= center;
        z /= radius;
        z /= dot(z,z);
        z *= radius;
        z.x += center;

        return z;
    }
}





//measure the distance to a geodesic
float dist(vec2 z, Geodesic geo){

    float endpt;

    //if its a vertical line
    if(isLine(geo,endpt)){
        //translate to the origin
        z.x-=endpt;
        //measure distance as angle
        float secTheta=length(z)/abs(z.y);
        return acosh(secTheta);
    }

    //otherwise, its a circle
    else{

        //build mobius transformation taking geo to (0,infty)
        vec4 mob=vec4(1.,-geo.p,1.,-geo.q);
        z = applyMobius(mob, z);

        //now measure the distance to this vertical line
        //measure distance as angle
        float secTheta=length(z)/abs(z.y);
        return acosh(secTheta);
    }
}








//------------------------------------------
//Half Spaces
//------------------------------------------


//a half space is bounded by a geodesic,
//and is all the area on one side of it
//side is + if it contains a portion of the real line (bounded area in model)
//side is - if it contains infinity
struct HalfSpace{
    Geodesic bdy;
    float side;
};



//inside checks if you are in a half space or not:
bool inside(vec2 z, HalfSpace hs){

    float endpt;

    //if the half space is bounded by a line:
    if( isLine( hs.bdy, endpt ) ){

        //is point to the right (+) or left (-) of the boundary?
        float side = sign(z.x - endpt);

        //check if this is inside (+) or outside (-) the halfspace
        return side*hs.side>0.;
    }

    //otherwise, the half space is bounded by a circle
    //endpoint was never assigned so dont use it
    else{

        float center = (hs.bdy.p+hs.bdy.q)/2.;
        float radius = abs((hs.bdy.p-hs.bdy.q))/2.;

        //get relative position
        vec2 rel = z-toC(center);
        //get radius
        float dist2 = dot(rel,rel);

        //get inside (-) or outside (+) circle
        float side = sign(dist2-radius*radius);

        //return true (+) if in half space, false if not
        return side*hs.side>0.;
    }
}



//reflect into a half space:
//if you are inside already, do nothing
//if you are outside, reflect in the boundary
vec2 reflectIn( vec2 z, HalfSpace hs) {
    if(!inside(z,hs)){
        vec2 res = reflectIn(z,hs.bdy);
        return res;
    }

    return z;
}




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
