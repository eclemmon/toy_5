s = Server.default.boot;

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
	arg out=0, freq, amp= 0.7, dur=1;
	var env = EnvGen.kr(Env.perc(0.05, MouseX.kr(0.05, 1)), doneAction: 2);
	var sig = SinOsc.ar(freq) * SinOsc.ar(MouseY.kr(1, 100)) * env;
	Out.ar(out, sig * amp);
}).add;
)

(
// Progression, Modify as you see fit!
~progression = [
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

~tFunc = {arg frequencies, numnotes, time_to_wait;
	var task;
	task = Task({
		var freqs, durs, amps;
		// frequencies for the notes, passed in from progression
		freqs = frequencies;
		freqs.postln;
		// calculate an array of amplitudes for the notes
		amps = Array.fill(numnotes, {arg i; (i + 1).reciprocal});
		// amps.postln;
		// now generate the notes
		inf.do({
			Synth(\chimes1, [\freq, freqs.midicps.choose, \out, 99, \amp, amps.choose]);
			0.1.rrand(0.5).wait;// and wait a bit between each new note
			})
	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray = Array.fill(~progression.size, {arg i; ~tFunc.value(~progression[i], 10.rrand(20), ~mouseX)});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks

~tFuncArrayTask = Task({
	~tFuncArray.do({arg aTask, i;
		aTask.postln;
		aTask.play;
		5.rrand(5).wait;
	});
});
)

(
Synth(\reverb, [\in, 99]);
~tFuncArrayTask.play;
)