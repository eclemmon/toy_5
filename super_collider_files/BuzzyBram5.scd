
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
	pan = MouseX.kr(-1,1);
	Out.ar(out, Pan2.ar(reverb, pan));
}).add;

SynthDef(\buzzy_bramm, {
	arg amp=4, out=0, freq;
	var pan, sig, trigger, saw, lpf;
	saw = LFSaw.ar(freq, mul:0.1);
	lpf = LPF.ar(saw, 400);
	sig = SinOsc.ar(freq, mul: lpf)*amp;
	pan = MouseY.kr(1,-1);
	trigger = MouseButton.kr(0,0.99,0.2);
	Out.ar(out, Pan2.ar(sig, pan, trigger));
}).add;

SynthDef(\buzzy_bramm2, {
	arg amp=4, out=0, freq;
	var pan, sig, trigger, saw, lpf;
	saw = LFSaw.ar(freq, mul:0.1);
	lpf = LPF.ar(saw, 1000);
	sig = SinOsc.ar(freq, mul: lpf)*amp;
	pan = MouseY.kr(1,1);
	trigger = MouseButton.kr(0,0.99,0.2);
	Out.ar(out, Pan2.ar(sig, pan, trigger));
}).add;

SynthDef(\fog_horn, {
	arg out=0, dur=15, amp, attack=0.1, release=0.1, decay_time=0.1, decay_amp=0.7, freq=440, fmod_freq=533, fmod_mul=200, sustain_freq=660, pos=0, filter_env_start_freq=880, filter_env_end_freq=440, filter_sus_dur=15, filter_decay_dur=0.1, filter_release_time=0.1, tail_length=4, tail_length_level=0.1;
	var pan, sig, env, filter, carrier, modulator, fmod_env, filter_env, trig;
	trig = Trig.kr(KeyState.kr(51, maxval:1, lag: 0.01));
	fmod_env = EnvGen.kr(Env([0,1,1,tail_length_level,tail_length_level, 0], [attack, (dur/2)-attack-(tail_length/2)-0.1, tail_length, (dur/2)-(tail_length/2), 0.1], curve: 'wel'), gate: trig);
	filter_env = EnvGen.kr(
		Env([0.1, filter_env_start_freq, sustain_freq, sustain_freq, filter_env_end_freq], [attack, filter_decay_dur, filter_sus_dur-attack-filter_decay_dur-release, filter_release_time], curve: -3), gate: trig);
	modulator = SinOsc.ar(MouseY.kr(0+fmod_freq, 1000+fmod_freq, warp: 1, lag: 0.2), mul: fmod_mul);
	carrier = SinOsc.ar(freq+(modulator*fmod_env));
	env = EnvGen.kr(
		Env([0,1,decay_amp,1,0], [attack, decay_time, dur-attack-release-decay_time-tail_length, tail_length], curve: ['wel', -2.0, -3, 0, -4]),
		gate: trig);
	sig = carrier * env;
	filter = LPF.ar(sig, filter_env);
	pan = Pan2.ar(filter, pos: pos, level: amp);
	Out.ar(out, pan);
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
			~buzzy_bram2.set(\freq, freqs[0]);
			~fog_horn.set(\freq, frequencies[0], \fmod_freq, frequencies[0]);
			// Synth(\buzzy_bramm, [\freq_list, freqs]);
			} {
			~buzzy_bram1.set(\freq, freqs[0]);
				~fog_horn.set(\freq, frequencies[0], \fmod_freq, frequencies[0]);
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
			"Phrase ".catArgs(phraseNo, " is complete.").postln;
			phraseNo = phraseNo + 1;
		} { "Phrase" };
		aTask.play;
		3.wait;
	});
});
)

// ########   2. Boot up the synths and GUI! ########
(
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
	~scope.yZoom = 1;
	~bus_scope_synth.setCycle(1024);
	w.view.mouseDownAction = { arg view, char, modifiers, unicode, keycode;
		~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];
		};
	w.view.mouseUpAction = {w.background = Color.gray};
	w.front; // something safe to type on
	// w.fullScreen; // COMMENT THIS IN IF YOU HAVE A DUAL MONITOR SET UP
	CmdPeriod.doOnce({w.close;});
};
);

Synth(\reverb3, [\in, 97]);
~buzzy_bram1 = Synth(\buzzy_bramm, [\freq, 33, \out, 97]);
~buzzy_bram2 = Synth(\buzzy_bramm2, [\freq, 3, \out, 97]);
~fog_horn = Synth(\fog_horn, [
	\out, 97,
	\amp, 0.1,
	\dur, 5,
	\attack, 0.01,
	\decay_time, 0.4,
	\decay_amp, 0.1,
	\sustain_freq, 2000.rand,
	\pos, 0,
	\filter_env_start_freq, 660,
	\filter_env_end_freq, 330,
	\filter_decay_dur, 0.2,
	\filter_release_time, 3.0,
	\tail_length, 3.0,
	\tail_length_level, 0.7,
	\freq, 60.midicps,
	\fmod_freq, 24.midicps
]);
)
// ########   3. Start the task on go! ########
(
~tFuncArrayTask2.play;
)