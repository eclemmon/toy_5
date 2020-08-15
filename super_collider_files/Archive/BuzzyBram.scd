s = Server.default.boot;

(
// Reverb and SynthDefs for BRAMMMMMMMMM
SynthDef(\reverb3, {
	| in = 97, out = 0 |
	var input, reverb, pan;
	input = In.ar(in);
	reverb = FreeVerb.ar(input, mix: 0.33, room: 0.9);
	pan = MouseY.kr(-1,1);
	Out.ar(out, Pan2.ar(reverb, pan));
}).add;

SynthDef(\buzzy_bramm, {
	arg amp, out=0, freq; var pan, sig, trigger, saw, lpf;
	saw = LFSaw.ar(freq, mul:0.01);
	lpf = LPF.ar(saw, 500);
	sig = SinOsc.ar(freq, mul: amp)*0.5+lpf;
	pan = MouseY.kr(-1,1);
	trigger = MouseButton.kr(0,1,0.2);
	Out.ar(out, Pan2.ar(sig, pan, trigger).dup);
}).add;
)

(
Synth(\reverb3, [\in, 97]);
Synth(\buzzy_bramm, [\amp, 0.5, \out, 97]);
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

~tFunc2 = {arg frequencies;
	var task;
	task = Task({
		var freqs, mousePosition, freq_size, index;
		// frequencies for the notes, passed in from progression
		freqs = frequencies-24;
		freqs.postln;
		freq_size = freqs.size;
		// now generate the notes
		~bramm.set(\freq, freqs[0].midicps);
	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray2 = Array.fill(~progression.size, {arg i; ~tFunc2.value(~progression[i])});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks

~tFuncArrayTask2 = Task({
	~tFuncArray2.do({arg aTask, i;
		aTask.play;
		5.rrand(5).wait;
	});
});
)

(
Synth(\reverb3, [\in, 97]);
~bramm = Synth(\buzzy_bramm, [\freq, (57-36).midicps, \out, 97]);
~tFuncArrayTask2.play;
)