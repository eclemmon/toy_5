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
	var freq = Index.ar(bufnum, MouseX.kr(0, BufSamples.kr(bufnum)));
	var mouseTrig = MouseButton.kr(1, Lag.ar(SinOsc.ar(MouseY.kr(50, 100, warp: 1, lag: 0.1), mul: 8)));
	var sig = SinOsc.ar(Lag.ar(freq.midicps, 0.075)) * env * mouseTrig;
	var amplitude = MouseButton.kr(amp, 0.9);
	Out.ar(out, sig * amplitude.dup);
}).add;

SynthDef(\chimes3, {
	arg out=50, amp=0.1, dur=1, bufnum;
	var trig = Trig.kr(KeyState.kr(51, maxval:1, lag: 0.01));
	var env = EnvGen.kr(Env.perc(0.05, MouseY.kr(0.05, 2)), gate: trig);
	var freq = WrapIndex.ar(bufnum, MouseX.kr(0, BufSamples.kr(bufnum) * 3));
	var mouseTrig = MouseButton.kr(1, Lag.ar(SinOsc.ar(MouseY.kr(50, 100, warp: 1, lag: 0.1), mul: 8)));
	var sig = SinOsc.ar(Lag.ar(freq.midicps, 0.075)) * env * mouseTrig;
	var amplitude = MouseButton.kr(amp, 0.9);
	Out.ar(out, sig * amplitude.dup);
}).add;

SynthDef(\delay, {
	arg in=89, out=99, amp=0.7, delayTime=1;
	var input, delay;
	input = In.ar(in);
	delay = DelayC.ar(input, maxdelaytime: delayTime, delaytime: delayTime);
	Out.ar(out, [delay, delay]);
}).add;

SynthDef(\delay2, {
	arg in=50, out=99, amp=0.7, randArray = #[0.2, 0.33, 0.5, 0.7, 0.8463, 1.3737, 1, 1.657347, 1.86484, 2];
	var input, delay, arrayIndex, delayTime;
	arrayIndex = TIRand.ar(lo: 0, hi: 9, trig: Trig.ar(KeyState.kr(51, maxval:1, lag: 0)));
	delayTime = Select.kr(arrayIndex, randArray);
	input = In.ar(in);
	delay = DelayC.ar(input, maxdelaytime: Lag.kr(delayTime, 0.5), delaytime: Lag.kr(delayTime, 0.5));
	Out.ar(out, [delay, delay]);
}).add;

SynthDef(\hermannKlank, {
	arg out=99, amp=0;
	var env = Lag.kr(amp, lagTime:0.2);
	var sig = Array.fill(7, {arg i;
		DynKlank.ar(`[[1,2,3,4,5,8,9,11,14], nil, [10,5,3,2,1,1,0.2,0.2,0.1]],
			input: Decay.ar(
				Impulse.ar(MouseX.kr((0.5*i+1), (1*i+1), warp: 1),
					0.1, WhiteNoise.ar(0.02))),
			freqscale: MouseY.kr((i*7+20).midicps, (i*7+100).midicps, warp: 1))});
	Out.ar(out, 0.2*sig!2*0.5*env);
}).add;

~klank = Synth(\hermannKlank);

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

~progressBarIndex = 0;
~progressBarWarningText = 3;
~progressBarStopText = 5;


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

		{
			if (~progressBarIndex <= 128) {
				if ((~progressBarIndex <= 82) || (~progressBarIndex > 90)) {
					~progressBar[~progressBarIndex].background = Color.green;
				} {
					if (~progressBarIndex <= 85) {
						~progressBar[~progressBarIndex].background = Color.yellow;
						~progressBar[~progressBarIndex].string = ~progressBarWarningText.asString;
						~progressBarWarningText = ~progressBarWarningText - 1;
					} {
						~progressBar[~progressBarIndex].background = Color.red;
						~progressBar[~progressBarIndex].string = ~progressBarStopText.asString;
						~progressBarStopText = ~progressBarStopText - 1;
					};
				};


				~progressBarIndex = ~progressBarIndex + 1;
			};
		}.defer;

	}); // this is where the Task ends
};

// ~tFuncArray is an array of Tasks
~tFuncArray = Array.fill(~progression.size, {arg i; ~tFunc.value(~progression[i], 10.rrand(20))});

// iterate through the array of Tasks, play them, and wait in between, with a Task of Tasks
~tFuncArrayTask = Task({
	var phraseNo = 0;
	~tFuncArray.do({arg aTask, i;
		// aTask.postln;
		if (i % 32 == 0) {
			if(phraseNo == 0) {
				"The piece has started.".postln;
				phraseNo = phraseNo + 1;
			} {
				"Phrase ".catArgs(phraseNo, " is complete.").postln;
				phraseNo = phraseNo + 1;
		};
		} { "Phrase" };
		aTask.play;
		3.wait;
		aTask.stop;
	});
});

)