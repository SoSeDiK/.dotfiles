precision mediump float;

varying vec2 v_texcoord;
uniform sampler2D tex;

const float threshold = 0.1; // Adjust threshold as needed

void main() {
    // Sample the color from the texture
    vec4 pixColor = texture2D(tex, v_texcoord);
    
    // Calculate the luminance of the pixel color
    float luminance = dot(pixColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    
    // Check if the luminance is below the threshold
    if (luminance < threshold) {
        // Set the alpha to 0.0 if the luminance is below the threshold
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        // Otherwise, use the original pixel color
        gl_FragColor = pixColor;
    }
}
