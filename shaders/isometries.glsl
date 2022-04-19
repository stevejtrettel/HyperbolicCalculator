

//----------------------------------------------
//------------------------------------------
//Upper Half Plane
//------------------------------------------
//----------------------------------------------

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




//return result of the isometry in stab(infty) which sends origin to p, applied to z
vec2 originToP(vec2 p, vec2 z){
    float x = p.x;
    float y = p.y;

    //expand by y
    z = y*z;

    //slide by x
    z=z+vec2(x,0);

    //together this took (0,1) to (0,y) to (x,y)
    return z;
}


vec2 pToOrigin(vec2 p, vec2 z){
    float x = p.x;
    float y = p.y;
    float r = x;

    //slide by x
    z = z - vec2(x, 0.);

    //divide by y
    z = z/y;

    //now; p has been moved to (x,y)->(0,y)->(0,1)
    //which is the origin of UHP
    return z;
}




//----------------------------------------------
//------------------------------------------
//Poincare Disk
//------------------------------------------
//----------------------------------------------


//uses mouse position to make a mobius transformation
//this is in the POINCARE DISK MODEL
//vec2 mouseTransform(vec2 z){
//    if (iMouse.z>0.) {
//        vec2 m = normalizeCoords(iMouse.xy);
//        // Unit disc inversion
//        m /= dot(m,m);
//        z -= m;
//        float k = (dot(m,m)-1.0)/dot(z,z);
//        z *= k;
//        z += m;
//    }
//    return z;
//}
//
