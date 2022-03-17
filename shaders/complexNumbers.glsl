
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

