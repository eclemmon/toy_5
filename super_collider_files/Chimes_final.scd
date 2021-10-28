// CHECK SETTINGS OF COMP
ServerOptions.outDevices;
ServerOptions.inDevices;

// 0. Boot Server
(
Server.default.options.outDevice_("multi_output_scarlett");
Server.default.options.inDevice_("Scarlett 2i2 USB");
// Server.default.options.outDevice_("MacBook Pro Speakers");
// Server.default.options.outDevice_("BlackHole 16ch");
// Server.default.options.inDevice_("MacBook Pro Microphone");
s = Server.default.boot;
)


// ########## 1. Initialize Everything (DO IT TWICE!) ##########
(
var cwd = thisProcess.nowExecutingPath.dirname;
thisProcess.interpreter.executeFile(cwd ++ "/chimes/initialization.scd");
)

// ########   2. Boot it up and then press the 'delete' key    ########
(
var cwd = thisProcess.nowExecutingPath.dirname;
thisProcess.interpreter.executeFile(cwd ++ "/chimes/gui.scd");
(
~tFuncArrayTask.play;
)
)


// If you neeed to pause it to discuss...
(
~tFuncArrayTask.stop;
)
