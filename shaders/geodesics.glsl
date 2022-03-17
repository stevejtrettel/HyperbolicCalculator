

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






