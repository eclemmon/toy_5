
// CHECK SETTINGS OF COMP
ServerOptions.outDevices;

// 0. Boot Server
(
Server.default.options.outDevice_("External Headphones");
s = Server.default.boot;
)

// ########## 1. Initialize SynthDefs Construct the progression and load tasks into memory. ##########
(
var cwd = thisProcess.nowExecutingPath.dirname;
thisProcess.interpreter.executeFile(cwd ++ "/bass/initialization.scd");
)

// ########   2. Boot up the synths and GUI, Start the task on go! ! ########
(
var cwd = thisProcess.nowExecutingPath.dirname;
thisProcess.interpreter.executeFile(cwd ++ "/bass/gui.scd");
~tFuncArrayTask2.play;
)
