(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
var scene, renderer, camera, clock, uniforms;

var glslify = require("glslify")

init();
animate();

/*
 * Initializes the sketch
 */
function init() {
	// Scene setup
	scene = new THREE.Scene();

	// Get the WebGL renderer
	renderer = new THREE.WebGLRenderer();
	renderer.setPixelRatio(window.devicePixelRatio);

	// Add the renderer to the sketch container
	document.getElementById("container").appendChild(renderer.domElement);

	// Camera setup
	camera = new THREE.Camera();
	camera.position.z = 1;

	// Initialize the clock
	clock = new THREE.Clock(true);

	// Create the plane geometry
	var geometry = new THREE.PlaneBufferGeometry(2, 2);

	// Define the shader uniforms
	uniforms = {
		u_time : {
			type : "f",
			value : 1.0
		},
		u_resolution : {
			type : "v2",
			value : new THREE.Vector2()
		},
		u_mouse : {
			type : "v2",
			value : new THREE.Vector2()
		}
	};

	// Create the shader material
	var material = new THREE.ShaderMaterial({
		uniforms : uniforms,
		vertexShader : glslify(["#define GLSLIFY 1\n#define GLSLIFY 1\nvoid main() {\n\tgl_Position = vec4(position, 1.0);\n}\n"]),
		fragmentShader : glslify(["#define GLSLIFY 1\n#define GLSLIFY 1\nuniform vec2 u_resolution;\nuniform vec2 u_mouse;\nuniform float u_time;\n\n// Import the random function\nhighp float random(vec2 co)\n{\n    highp float a = 12.9898;\n    highp float b = 78.233;\n    highp float c = 43758.5453;\n    highp float dt= dot(co.xy ,vec2(a,b));\n    highp float sn= mod(dt,3.14);\n    return fract(sin(sn) * c);\n}\n\nvoid main() {\n\tfloat n = random((gl_FragCoord.xy - u_mouse) / u_resolution.xy);\n\tgl_FragColor = vec4(vec3(n), 1.0);\n}\n"])
	});

	// Create the mesh
	var mesh = new THREE.Mesh(geometry, material);

	// Add the mesh to the scene
	scene.add(mesh);

	// Update the uniforms
	onWindowResize();

	// Add the event listeners
	window.addEventListener("resize", onWindowResize, false);
	document.addEventListener("mousemove", onMouseMove, false);
}

/*
 * Animates the sketch
 */
function animate() {
	requestAnimationFrame(animate);
	render();
}

/*
 * Renders the sketch
 */
function render() {
	uniforms.u_time.value = clock.getElapsedTime();
	renderer.render(scene, camera);
}

/*
 * Updates the renderer size and the uniform values when the window is resized
 */
function onWindowResize(event) {
	renderer.setSize(window.innerWidth, window.innerHeight);
	uniforms.u_resolution.value.x = renderer.domElement.width;
	uniforms.u_resolution.value.y = renderer.domElement.height;
}

/*
 * Updates the uniform values when the mouse moves
 */
function onMouseMove(event) {
	uniforms.u_mouse.value.x = event.pageX
	uniforms.u_mouse.value.y = event.pageY
}

},{"glslify":2}],2:[function(require,module,exports){
module.exports = function(strings) {
  if (typeof strings === 'string') strings = [strings]
  var exprs = [].slice.call(arguments,1)
  var parts = []
  for (var i = 0; i < strings.length-1; i++) {
    parts.push(strings[i], exprs[i] || '')
  }
  parts.push(strings[i])
  return parts.join('')
}

},{}]},{},[1]);
