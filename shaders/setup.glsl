//basic setup for the shader:
//useful constants, color schemes, normalizing the viewport etc

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

float P = 2.;
float Q = 3.;
float R = 7.;


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



