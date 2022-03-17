

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
