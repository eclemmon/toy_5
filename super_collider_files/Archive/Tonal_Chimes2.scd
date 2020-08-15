s = Server.default.boot;

// SYNTHDEFS
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
// Reverb and SynthDefs for Granulated Sins
SynthDef(\reverb2, {
	| in = 98, out = 0 |
	var
	input = In.ar(in),
	reverb = FreeVerb.ar(input, mix: 0.33, room: 1);

	Out.ar(out, [reverb, reverb]);
}).add;

SynthDef(\sinegrain, {
	arg pan, freq, amp, out=0; var grain, ampMod;
	ampMod = SinOsc.ar(MouseY.kr(1, 500), mul:0.5);
	grain=SinOsc.ar(MouseX.kr(100, 400, 1)*ampMod, 0, amp)*(XLine.kr(1.001,0.001,0.1,doneAction:2)-0.001);
	Out.ar(out,Pan2.ar(grain, pan))}).add;
)


(
// Reverb and SynthDefs for BRAMMMMMMMMM
SynthDef(\reverb3, {
	| in = 97, out = 0 |
	var input, reverb, pan;
	input = In.ar(in);
	reverb = FreeVerb.ar(input, mix: 0.33, room: 1);
	pan = MouseY.kr(-1,1);
	Out.ar(out, Pan2.ar(reverb, pan));
}).add;

/*SynthDef(\buzzy_bramm, {
	arg amp, out=0; var pan, sig, trigger;
	sig = SinOsc.ar(MouseX.kr(40, 4000, 1), mul: amp)*LFSaw.ar(MouseX.kr(40,4000,1), mul:amp)*0.5;
	trigger = MouseButton.kr(0,1,0.2);
	pan = Balance2.ar(sig, sig, MouseY.kr(-1,1))*trigger;
	Out.ar(out, [pan, pan]);
}).add;*/

SynthDef(\buzzy_bramm, {
	arg amp, out=0; var pan, sig, trigger;
	sig = SinOsc.ar(MouseX.kr(40, 100, 1), mul: amp)*LFSaw.ar(MouseX.kr(40,100,1), mul:0.1)*0.5;
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
Synth(\reverb, [\in, 98]);
{
inf.do{
	Synth(\sinegrain,[\amp, exprand(0.05,0.1), \pan, 1.0.rand2, \out, 98]);
	0.1.rand.wait;
};
}.fork
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
			0.1.rrand(0.1).wait;// and wait a bit between each new note
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
			0.1.rrand(0.1).wait;// and wait a bit between each new note
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




