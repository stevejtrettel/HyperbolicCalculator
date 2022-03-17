




//Build Accumulation Scene
//=============================================

async function buildShader() {

    let newShader = '';


    const shaders = [] = [
        {file: './shaders/setup.glsl'},
        {file: './shaders/complexNumbers.glsl'},
        {file: './shaders/modelConversions.glsl'},
        {file: './shaders/isometries.glsl'},
        {file: './shaders/pointsAndCircles.glsl'},
        {file: './shaders/horocycles.glsl'},
        {file: './shaders/geodesics.glsl'},
        {file: './shaders/halfSpaces.glsl'},
        {file: './shaders/polygons.glsl'},
        {file: './shaders/main.glsl'},
    ];


    //loop over the list of files
    let response, text;
    for (const shader of shaders) {
        response = await fetch(shader.file);
        text = await response.text();
        newShader = newShader + text;
    }

    return newShader;

}






export { buildShader };
