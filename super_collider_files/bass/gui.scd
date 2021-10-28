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
	\amp, 0.06,
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