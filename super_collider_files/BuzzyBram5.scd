// CHECK SETTINGS OF COMP
ServerOptions.outDevices;

// 0. Boot Server
(
Server.default.options.outDevice_("Multi-Output Device");
s = Server.default.boot;
)

// ########## 1. Initialize SynthDefs Construct the progression and load tasks into memory. ##########
(
// Reverb and SynthDefs for BRAMMMMMMMMM
SynthDef(\reverb3, {
	| in = 97, out = 0, amp=4 |
	var input, reverb, pan;
	input = In.ar(in);
	reverb = FreeVerb.ar(input, mix: 0.33, room: 0.9) * amp;
	pan = MouseY.kr(-1,1);
	Out.ar(out, Pan2.ar(reverb, pan));
}).add;

SynthDef(\buzzy_bramm, {
	arg amp=4, out=0, freq_list = #[40,50,60,70], freq;
	var pan, sig, trigger, saw, lpf, idx;
	idx = 0;
	// freq = freq_list[idx].midicps;
	saw = LFSaw.ar(freq, mul:0.1);
	lpf = LPF.ar(saw, 400);
	sig = SinOsc.ar(freq, mul: lpf)*amp;
	pan = MouseY.kr(-1,1);
	trigger = MouseButton.kr(0,1,0.2);
	Out.ar(out, Pan2.ar(sig, pan, trigger));
}).add;

SynthDef(\buzzy_bramm2, {
	arg amp=4, out=0, freq_list = #[50,60,70], freq;
	var pan, sig, trigger, saw, lpf, idx;
	idx = 0;
	// freq = freq_list[idx].midicps;
	saw = LFSaw.ar(freq, mul:0.1);
	lpf = LPF.ar(saw, 1000);
	sig = SinOsc.ar(freq, mul: lpf)*amp;
	pan = MouseY.kr(-1,1);
	trigger = MouseButton.kr(0,1,0.2);
	Out.ar(out, Pan2.ar(sig, pan, trigger));
}).add;

// Progression, Modify as you see fit!
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

~tFunc2 = {arg frequencies;
	var task;
	task = Task({
		var freqs, mousePosition, freq_size, index;
		// frequencies for the notes, passed in from progression
		if (frequencies[0]-24 < 29) {
			freqs = frequencies - 12;
		}{
			freqs = frequencies-24;
		};
		freqs.postln;
		freq_size = freqs.size;
		// now generate the notes
		if (freqs.size > 3) {
			~buzzy_bram2.set(\freq_, freqs[0]);
			// Synth(\buzzy_bramm, [\freq_list, freqs]);
			} {
			~buzzy_bram1.set(\freq, freqs[0]);
			// Synth(\buzzy_bramm2, [\freq_list, freqs]);
			};
	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray2 = Array.fill(~progression.size, {arg i; ~tFunc2.value(~progression[i])});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks

~tFuncArrayTask2 = Task({
	var phraseNo = 0;
	~tFuncArray2.do({arg aTask, i;
		if(i % 32 == 0) {
			"Phrase ".catArgs(phraseNo+1, " beginning.").postln;
			phraseNo = phraseNo + 1;
		} { "Phrase" };
		aTask.play;
		3.wait;
	});
});
)

// ########   2. Boot it up and then click the mouse button  ########
(
(
// Initializes window that captures key presses and displays key state changes as a 'confirmation' that a key has been entered.
w = Window.new("I catch keystrokes", Rect(600,600,600,600));
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
	w.background = Color.green;
};
w.view.keyUpAction = {w.background = Color.gray};
);

(
w.front; // something safe to type on
);

Synth(\reverb3, [\in, 97]);
~buzzy_bram1 = Synth(\buzzy_bramm, [\freq_list, [ 33, 40, 45 ], \out, 97]);
~buzzy_bram2 = Synth(\buzzy_bramm2, [\freq_list, [ 25, 33, 33, 40 ], \out, 97]);
~tFuncArrayTask2.play;
)