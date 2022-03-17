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




