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
// Reverb and SynthDefs for Chime Sounds
SynthDef(\reverb, {
	| in = 99, out = 0, amp=0.7 |
	var
	input = In.ar(in),
	reverb = FreeVerb.ar(input, mix: 0.33, room: 0.33) * amp;
	Out.ar(out, [reverb, reverb]);
}).add;

SynthDef(\chimes2, {
	arg out=0, amp=0.1, dur=1, bufnum;
	var trig = Trig.kr(KeyState.kr(51, maxval:1, lag: 0.01));
	var env = EnvGen.kr(Env.perc(0.05, MouseY.kr(0.05, 2)), gate: trig);
	var freq = Index.kr(bufnum, MouseX.kr(0, BufSamples.kr(bufnum)));
	var mouseTrig = MouseButton.kr(1, SinOsc.ar(MouseY.kr(50, 100, warp: 1, lag: 0.1), mul: 2));
	var sig = SinOsc.ar(freq.midicps) * env * mouseTrig;
	var amplitude = MouseButton.kr(amp, 1);
	Out.ar(out, sig * amplitude.dup);
}).add;

// Progression, Modify as you see fit!
// 32 chords
~urprog = [
	[57, 64, 69],
	[56, 64, 69],
	[54, 64, 69],
	[54, 62, 69],
	[55, 66, 69],
	[59, 66, 69],
	[59, 65, 69],
	[60, 67, 72],
	[60, 67, 74],
	[59, 67, 74],
	[57, 67, 74],
	[57, 67, 72],
	[56, 67, 72],
	[55, 64, 71],
	[55, 62, 71],
	[60, 62, 71],
	[60, 62, 69],
	[56, 62, 69],
	[56, 64, 69],
	[57, 64, 69],
	[45, 52, 57],
	[49, 57, 57, 64],
	[50, 57, 57, 66],
	[47, 55, 62],
	[45, 55, 60],
	[45, 53, 60],
	[45, 53, 61],
	[45, 53, 62],
	[45, 53, 62, 69],
	[44, 53, 62, 69],
	[45, 52, 57, 64],
	[45, 52, 57]
];

~progression = Array.new();

(0..2).do( {arg num;
	~urprog.do( {arg subArray, index;
		var newArray;
		newArray = Array.newFrom(subArray);
		newArray[0] = newArray[0] + num;
		newArray[1] = newArray[1] + num;
		~progression = ~progression.add(newArray);
	});
});
~progression = ~progression ++ ~urprog;
~progression = ~progression ++ [57, 64, 69];
~progression;


// Initialize buffers and synths for playback.
b = Buffer.alloc(s, 4);
b.setn(0, [57, 64, 69, 57]);
b.getn(0, b.numFrames, {|msg| msg.postln});
~reverb = Synth(\reverb, [\in, 99]);
~synth = Synth.new(\chimes2, [\out, 99, \bufnum, b]);

~tFunc = {arg frequencies, numnotes;
	~mainTask = Task({
		var freqs, durs, amps;
		// frequencies for the notes, passed in from progression
		freqs = frequencies;

		// Just a conditional that makes all the notes arrays the same size.
		if (freqs.size > 3) {
			freqs = freqs;
			b.setn(0, freqs);
		} {
			freqs = freqs ++ freqs[0];
			b.setn(0, freqs);
		};
		b.getn(0, b.numFrames, {|msg| msg.postln});

	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray = Array.fill(~progression.size, {arg i; ~tFunc.value(~progression[i], 10.rrand(20))});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks
~tFuncArrayTask = Task({
	var phraseNo = 0;
	~tFuncArray.do({arg aTask, i;
		// aTask.postln;
		if(i % 32 == 0) {
			"Phrase ".catArgs(phraseNo, " is complete.").postln;
			phraseNo = phraseNo + 1;
		} { "Phrase" };
		aTask.play;
		3.wait;
		aTask.stop;
	});
});
)

// ########   2. Boot it up and then press the 'delete' key    ########
(
// Initializes window that captures key presses and displays key state changes as a 'confirmation' that a key has been entered.
(

s.waitForBoot {
	w = Window.new("I catch keystrokes", Window.availableBounds, true, true);
	~scope = QScope2(w.view, w.view.bounds);
	~bus_scope_synth = BusScopeSynth(s);
	~scope.server = s;
	~bus_scope_synth.play(4096, Bus('audio', 0, 2, s));
	s.sync;
	~scope.bufnum= ~bus_scope_synth.bufferIndex;
	~scope.server= s;
	~scope.start;
	~scope.style = 1;
	~scope.yZoom = 20;
	~scope.xZoom = 1;
	~bus_scope_synth.setCycle(4096);
	~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];

	w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
		~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];
		};
	w.view.keyUpAction = {w.background = Color.gray};
	w.front; // something safe to type on
	// w.fullScreen; // COMMENT THIS IN IF YOU HAVE A DUAL MONITOR SET UP
	CmdPeriod.doOnce({w.close;});
};

);
)

(
~tFuncArrayTask.play;
)

// If you neeed to pause it to discuss...
(
~tFuncArrayTask.stop;
)
