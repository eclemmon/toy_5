s = Server.default.boot;

// Initialize SynthDefs
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
	arg amp, out=0, freq_list = #[40,50,60,70], freq_size=4, freqIndex=1;
	var pan, sig, trigger, saw, lpf, idx, freq;
	idx = 1;
	freq = freq_list[idx];
	saw = LFSaw.ar(freq, mul:0.01);
	lpf = LPF.ar(saw, 500);
	sig = SinOsc.ar(freq, mul: amp)*0.5+lpf;
	pan = MouseY.kr(-1,1);
	trigger = MouseButton.kr(0,1,0.2);
	Out.ar(out, Pan2.ar(sig, pan, trigger).dup);
}).add;
)

// (
// Synth(\reverb3, [\in, 97]);
// x = Synth(\buzzy_bramm, [\freq_list, [1500,50,60,70], \amp, 0.5, \out, 97, \freq_size, 4]);
// x.setn(\freq_list, [1500,50,60,70]);
// )



// (
// {
// 	SendReply.kr(Impulse.kr(8), '/the_answer', MouseX.kr, 1905);
// }.play(s);
// )
//
// o = OSCFunc({ |msg| msg.postln }, '/the_answer');


// Construct the progression and load into memory.
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
	[45, 52, 57],
];


/*~progression = Array.fill(4, {arg i;
	~urprog.do( {arg subArray, index;
		~urprog[index][0] = subArray[0] + 1;
		~urprog[index][1] = subArray[1] + 1;
	});
});*/

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
~progression;
)


// Build the task of tasks.
(

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
		1.rrand(5).wait;
	});
});
)

// Gimme that Hans Zimmer bram fam.
(
Synth(\reverb3, [\in, 97]);
~bramm = Synth(\buzzy_bramm, [\freq, (57-36).midicps, \out, 97]);
~tFuncArrayTask2.play;
)