var cwd = thisProcess.nowExecutingPath.dirname;
b = Buffer.read(s, cwd +/+ "samples/a11wlk01-44_1.aiff");
c = Buffer.readChannel(s, cwd +/+ "samples/helicopter.wav", 0, channels: [0]);

SynthDef.new(\low_creepy_granulation, {
	arg out, gate, amp, sndbuf, grainSize, freq, trigRate, maxRate;
	var pan1, pan2, env, sig, grain, amplitude, trig;
	trig = KeyState.kr(51, maxval:1, lag: 0.01);
	amplitude = MouseY.kr(0,0.99);
	pan1 = MouseX.kr(-1, 1);
	env = EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		levelScale: amp,
		doneAction: Done.freeSelf);
	grain = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.kr(trigRate),
		dur: grainSize,
		sndbuf: sndbuf,
		rate: LFNoise1.kr.range(1, maxRate),
		pos: LFNoise2.kr(0.1).range(0,1),
		interp: 2,
		pan: pan1,
		envbufnum: -1);
	sig = SinOsc.ar(freq.midicps) * grain * env * amplitude * trig;
	Out.ar(out, sig)
}).add;

SynthDef(\buf_grain_test, { |out, gate = 1, amp = 1, sndbuf, envbuf|
    var env, play_buf, grain_buf, trig, amplitude;
	amplitude = MouseY.kr(0,0.99);
	trig = KeyState.kr(36, maxval:1, lag: 0.01);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
	grain_buf = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(10),
		dur: 1,
		sndbuf: sndbuf,
		rate: MouseY.kr(0.5, 2.0),
		dur: LFNoise2.kr(0.1).range(0, 1),
		pos: LFNoise2.kr(0.1).range(0, 1),
		pan: MouseX.kr(-1, 1),
		envbufnum: envbuf);
    Out.ar(out, grain_buf * env * trig * amplitude)
}).add;


// UNIMPORTANT FOR THIS PART BUT NECESSARY TO KEEP TRACK OF OVERALL PROGRESSION OF PIECE
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
d = Buffer.alloc(s, 4);
d.setn(0, [57, 64, 69, 57]);
d.getn(0, d.numFrames, {|msg| msg.postln});

~tFunc = {arg frequencies, numnotes;
	~mainTask = Task({
		var freqs, durs, amps;
		// frequencies for the notes, passed in from progression
		freqs = frequencies;

		// Just a conditional that makes all the notes arrays the same size.
		if (freqs.size > 3) {
			freqs = freqs;
			d.setn(0, freqs);
		} {
			freqs = freqs ++ freqs[0];
			d.setn(0, freqs);
		};
		d.getn(0, d.numFrames, {|msg| msg.postln});

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