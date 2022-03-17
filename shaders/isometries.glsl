

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









//----------------------------------------------
//------------------------------------------
//Poincare Disk
//------------------------------------------
//----------------------------------------------


//uses mouse position to make a mobius transformation
//this is in the POINCARE DISK MODEL
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

