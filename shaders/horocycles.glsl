
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


