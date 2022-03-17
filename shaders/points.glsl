
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

