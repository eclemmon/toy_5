(
var outDevices, inDevices, winw, winh, columns, rows, outDevice, inDevice, compositeView, outDevicesSelector, inDevicesSelector, outDevicesSelectorText, inDevicesSelectorText, startButton, cwd, closeButton, partSelectorText, partSelector, parts, part;
~cwd = thisProcess.nowExecutingPath.dirname.asSymbol;
part = "chimes";

outDevices = ["Default"] ++ ServerOptions.outDevices;
inDevices = ["Default"] ++ ServerOptions.inDevices;
parts = ["chimes", "bass", "granulation"];

// Set number of rows and columns
columns = 4;
if ((outDevices.size >= inDevices.size), {
	rows = outDevices.size;
}, {
	rows = inDevices.size;
});

// Set window size
winw = 200 * columns + (columns * 10);
winh = 110;

// Build Window
w = Window.new("toy_5", Rect.new(Window.screenBounds.width/2, Window.screenBounds.height/2, winw, winh), true, true);
compositeView = CompositeView(w, w.view.bounds).background_(Color.fromHexString("#e6f1f0"));
compositeView.decorator = FlowLayout(compositeView.bounds, 10@10);

// Add selectors and buttons
inDevicesSelectorText = StaticText(compositeView, 200@40)
.string_("In Device Options")
.background_(Color.green(alpha: 0.2))
.align_(\center);

outDevicesSelectorText = StaticText(compositeView, 200@40)
.string_("Out Device Options")
.background_(Color.green(alpha: 0.2))
.align_(\center);

partSelectorText = StaticText(compositeView, 200@40)
.string_("Part")
.background_(Color.green(alpha: 0.2))
.align_(\center);

startButton = Button(compositeView, 200@40)
.states_([["START", Color.blue(alpha: 1), Color.green(alpha: 0.2)]])
.font_(Font("Impact", 30))
.action_({arg butt;
	var cwd;

	// Set inputs and outputs to equal so Server will always boot.
	Server.default.options.numInputBusChannels = 2;
	Server.default.options.numOutputBusChannels = 2;
	if ((outDevice == "Default"), {
		Server.default.options.outDevice = nil;
	}, {
		Server.default.options.outDevice = outDevice;
	});

	if ((inDevice == "Default"), {
		Server.default.options.inDevice = nil;
	}, {
		Server.default.options.inDevice = inDevice;
	});

	// "Out Device: " ++ Server.default.options.outDevice.postln;

	s = Server.default;
	cwd = ~cwd ++ "/" ++ part;
	cwd.postln;
	s.waitForBoot {
		thisProcess.interpreter.executeFile(cwd ++ "/initialization.scd");
		thisProcess.interpreter.executeFile(cwd ++ "/initialization.scd");
		0.5.wait;
		thisProcess.interpreter.executeFile(cwd ++ "/gui.scd");
		0.5.wait;
		~tFuncArrayTask.play;
	};
	w.close;

});

compositeView.decorator.nextLine;

inDevicesSelector = PopUpMenu(compositeView, 200@40)
.items_(inDevices)
.background_(Color.green(alpha: 0.6))
.action_({arg deviceName;
	outDevice = deviceName.item;
	outDevice.postln;
});

outDevicesSelector = PopUpMenu(compositeView, 200@40)
.items_(outDevices)
.background_(Color.green(alpha: 0.6))
.action_({arg deviceName;
	outDevice = deviceName.item;
	outDevice.postln;
});

partSelector = PopUpMenu(compositeView, 200@40)
.items_(parts)
.background_(Color.green(alpha: 0.6))
.action_({arg partName;
	part = partName.item;
	part.postln;
});

closeButton = Button(compositeView, 200@40)
.states_([["Close", Color.green(alpha: 1), Color.blue(alpha: 0.5)]])
.font_(Font("Impact", 30))
.action_({arg butt;
	w.close;
	thisProcess.shutdown;
	0.exit;
});

// Bring up window
w.front;
CmdPeriod.doOnce { ~endProgram };

~endProgram = {
	w.close;
	CmdPeriod.run;
	Server.killAll;
	0.exit;
};


)