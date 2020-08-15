// CHECK SETTINGS OF COMP
ServerOptions.outDevices;
ServerOptions.inDevices;

// 0. Boot Server
(
Server.default.options.outDevice_("Multi-Output Device");
Server.default.options.inDevice_("MacBook Pro Microphone");
s = Server.default.boot;
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
	var env = EnvGen.kr(Env.perc(0.05, MouseY.kr(0.05, 2)), doneAction: 2);
	var freq = Index.ar(LocalBuf.newFrom(freq_list), MouseX.kr(0, freq_list.size-0.001));
	var mouseTrig = MouseButton.kr(1, SinOsc.ar(MouseY.kr(1, 100), mul: 2));
	var sig = SinOsc.ar(freq.midicps) * env * mouseTrig;
	Out.ar(out, sig * amp);
}).add;


SynthDef(\chimes2, {
	arg out=0, freq_list=#[0,0,0,0], amp= 0.7, dur=1;
	var env = EnvGen.kr(Env.perc(0.05, MouseY.kr(0.05, 2)), doneAction: 2);
	var freq = Index.ar(LocalBuf.newFrom(freq_list), MouseX.kr(0, freq_list.size-0.001));
	var mouseTrig = MouseButton.kr(1, SinOsc.ar(MouseY.kr(1, 100), mul: 2));
	var sig = SinOsc.ar(freq.midicps) * env * mouseTrig;
	Out.ar(out, sig * amp);
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

(0..3).do( {arg num;
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
		amps = Array.fill(numnotes, {arg i; (i + 1).reciprocal});
		// amps.postln;
		// now generate the notes
		inf.do({
			if (freqs.size > 3) {
				Synth(\chimes2, [\freq_list, freqs, \out, 99, \amp, amps.choose]);
			} {
				Synth(\chimes1, [\freq_list, freqs, \out, 99, \amp, amps.choose]);
			};
			(0.1).rrand(0.75).wait;// and wait a bit between each new note
			})
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
Synth(\reverb, [\in, 99]);
~tFuncArrayTask.play;
)

// If you neeed to pause it to discuss...
(
~tFuncArrayTask.stop;
)

