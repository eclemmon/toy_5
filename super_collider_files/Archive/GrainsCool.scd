
(
Server.default.options.outDevice_("External Headphones");
Server.default.boot;
)

(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

SynthDef.new(\hey, {
	arg out, gate, amp, sndbuf, grainSize, freq, trigRate, maxRate;
	var pan1, pan2, env, sig, grain, amplitude;
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
	sig = SinOsc.ar(freq.midicps) * grain * env * amplitude;
	// pan2 = Pan2.ar(sig, pos: MouseX.kr(-1, 1));
	Out.ar(out, sig)
}).add;
//

SynthDef(\reverb, {
	| in = 99, out = 0 |
	var
	input = In.ar(in),
	reverb = FreeVerb.ar(input, mix: 0.33, room: 0.33);
	Out.ar(out, [reverb, reverb]);
}).add;

SynthDef(\SamSaro, {
	arg minFreq, growth, dur, out, ampGrowth, amp, freqGrowth;
	var env, sig;
	env = EnvGen.kr(Env.perc(0.2, dur), doneAction: Done.freeSelf);
	sig = Klang.ar(`[Array.geom(10, minFreq, freqGrowth), Array.geom(10, amp, ampGrowth), nil], 1, 0) * env;
	Out.ar(out, sig);
}).add;
)

(
Synth(\reverb, [\in, 99]);

x = Synth(\hey, [\out, 0, \gate, 1, \amp, 0.2, \sndbuf, b, \grainSize, 0.5, \freq, 40, \trigRate, 20, \maxRate, 0.001])
)
x.set(\freq, 70);
x.set(\freq, 80);
x.set(\freq, 90);
x.set(\freq, 2000);
x.set(\grainSize, 0.5);
x.set(\amp, 0.1);

(
var winenv;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\buf_grain_test, { |out, gate = 1, amp = 1, sndbuf, envbuf|
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
    Out.ar(out,
        GrainBuf.ar(2, Impulse.kr(10), 0.1, sndbuf, LFNoise1.kr.range(0.5, 2),
            LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
}).add;
)

x = Synth(\buf_grain_test);
