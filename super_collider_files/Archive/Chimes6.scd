// CHECK SETTINGS OF COMP
ServerOptions.outDevices;
ServerOptions.inDevices;

// 0. Boot Server
(
Server.default.options.outDevice_("External Headphones");
Server.default.options.inDevice_("MacBook Pro Microphone");
s = Server.default.boot;
)

(
w = Window.new("I catch keystrokes");
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, keycode].postln; };
)

// then execute this and then press the 'j' key
(
w.front; // something safe to type on
Synth(\chimes1, [\freq_list, [40,44,47]]);
)


// 1. Initialize SynthDefs
(
// Reverb and SynthDefs for Chime Sounds
SynthDef(\reverb, {
	| in = 99, out = 0 |
	var
	input = In.ar(in),
	reverb = FreeVerb.ar(input, mix: 0.33, room: 0.33);
	Out.ar(out, [reverb, reverb]);
}).add;

SynthDef(\chimes1, {
	arg out=0, freq_list=#[0,0,0], amp= 0.7, dur=1;
	var trig = Trig.kr(KeyState.kr(51, maxval:1, lag: 0.01));
	var env = EnvGen.kr(Env.perc(0.05, MouseY.kr(0.05, 2)), gate: trig);
	var freq = Index.ar(LocalBuf.newFrom(freq_list), MouseX.kr(0, freq_list.size-0.001));
	var mouseTrig = MouseButton.kr(1, SinOsc.ar(MouseY.kr(1, 100), mul: 2));
	var sig = SinOsc.ar(freq.midicps) * env * mouseTrig;
	Out.ar(out, sig * amp.dup);
}).add;



SynthDef(\chimes2, {
	arg out=0, freq_list=#[0,0,0,0], amp= 0.7, dur=1;
	var trig = Trig.kr(KeyState.kr(51, maxval:1, lag: 0.01));
	var env = EnvGen.kr(Env.perc(0.05, MouseY.kr(0.05, 2)), gate: trig);
	var freq = Index.ar(LocalBuf.newFrom(freq_list), MouseX.kr(0, freq_list.size-0.001));
	var mouseTrig = MouseButton.kr(1, SinOsc.ar(MouseY.kr(1, 100), mul: 2));
	var sig = SinOsc.ar(freq.midicps) * env * mouseTrig;
	Out.ar(out, sig * amp.dup);
}).add;
)

// 2. Construct the progression and load into memory.
(

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
~progression;
)


// 3. Build the task of tasks.
(

~tFunc = {arg frequencies, numnotes, time_to_wait;
	~mainTask = Task({
		var freqs, durs, amps;
		// frequencies for the notes, passed in from progression
		freqs = frequencies;
		freqs.postln;
		// calculate an array of amplitudes for the notes
		// amps.postln;
		// now generate the notes
		if (freqs.size > 3) {
			~chimes = Synth(\chimes2, [\freq_list, freqs, \out, 99]);
		} {
			~chimes = Synth(\chimes1, [\freq_list, freqs, \out, 99]);
		};
	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray = Array.fill(~progression.size, {arg i; ~tFunc.value(~progression[i], 10.rrand(20), ~numPlayers)});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks

~tFuncArrayTask = Task({
	~tFuncArray.do({arg aTask, i;
		// aTask.postln;
		aTask.play;
		3.wait;
		aTask.stop;
	});
});
)


(
~reverb = Synth(\reverb, [\in, 99]);

~tFunc = {arg frequencies, numnotes, time_to_wait;
	~mainTask = Task({
		var freqs, durs, amps;
		// frequencies for the notes, passed in from progression
		freqs = frequencies;
		freqs.postln;
		// now generate the notes
		~synth.free;
		~synth = Synth(\chimes2, [\out, 99, \freq_list, freqs]);
		if (freqs.size > 3) {
			~synth.set(\freq_list, freqs, \out, 99);
		} {
			freqs = freqs ++ freqs[0];
			"frequencies?".postln;
			freqs.postln;
			~synth.set(\freq_list, freqs, \out, 99);
		};
	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray = Array.fill(~progression.size, {arg i; ~tFunc.value(~progression[i], 10.rrand(20), ~numPlayers)});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks

~tFuncArrayTask = Task({
	~tFuncArray.do({arg aTask, i;
		// aTask.postln;
		aTask.play;
		3.wait;
		aTask.stop;
	});
});
)

// 4. Boot it up!

(
(
w = Window.new("I catch keystrokes");
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, keycode].postln; };
);

// then execute this and then press the 'delete' key
(
w.front; // something safe to type on
);

~tFuncArrayTask.play;
)

// If you neeed to pause it to discuss...
(
~tFuncArrayTask.stop;
)

