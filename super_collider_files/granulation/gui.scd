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
	~scope.style = 0;
	~scope.yZoom = 5;
	~bus_scope_synth.setCycle(1024);
	w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
		~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];
		};
	w.view.keyUpAction = {w.background = Color.gray};
	w.front; // something safe to type on
	// w.fullScreen; // COMMENT THIS IN IF YOU HAVE A DUAL MONITOR SET UP

	CmdPeriod.doOnce({w.close;});
};
);
Synth(\low_creepy_granulation, [\out, 0, \gate, 1, \amp, 0.5, \sndbuf, b, \grainSize, 0.5, \freq, 40, \trigRate, 20, \maxRate, 0.001]);
Synth(\buf_grain_test, [\sndbuf, c, \envbuf, -1, \out, 0]);
~tFuncArrayTask.play;