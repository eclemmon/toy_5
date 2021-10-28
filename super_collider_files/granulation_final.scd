// CHECK SETTINGS OF COMP
ServerOptions.outDevices;
ServerOptions.inDevices;

// 0. Boot Server
(
Server.default.options.outDevice_("multi_output_scarlett");
// Server.default.options.outDevice_("BlackHole 16ch");
Server.default.options.inDevice_("MacBook Pro Microphone");
s = Server.default.boot;
)


// ########## 1. Initialize Everything ##########
(
var cwd = thisProcess.nowExecutingPath.dirname;
thisProcess.interpreter.executeFile(cwd ++ "/granulation/initialization.scd");
)

// ########   2. Boot it up and then press 'delete' for creepy granulation and 'return' for helicopters  ########
(
var cwd = thisProcess.nowExecutingPath.dirname;
thisProcess.interpreter.executeFile(cwd ++ "/granulation/gui.scd");
)




