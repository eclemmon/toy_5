(
s.waitForBoot {
	var compView, quitButton;

	// Build window and flow layout
	w = Window.new("I catch keystrokes", Window.availableBounds, true, true);
	compView = CompositeView(w, Rect(0, 0, Window.screenBounds.width, Window.screenBounds.height-90));
	compView.decorator = FlowLayout(compView.bounds, 0@0, 0@0);

	// Build multicolor Scope
	~scope = QScope2(compView, compView.bounds.insetAll(0, 0, 0, 100));
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

	// Next Line
	compView.decorator.nextLine;

	~progressBar = Array.fill(~urprog.size * 4, {arg i;
		StaticText(compView, (compView.bounds.width - 300) / (~urprog.size * 4)@40).background_(Color.gray(gray: 1, alpha: 0.2));
	});

	// Quit Button
	quitButton = Button(compView, 200@90)
	.states_([["QUIT", Color.blue(alpha: 0.5), Color.green(alpha: 0.2)]])
	.font_(Font("Impact", 30))
	.action_({
		arg butt;
		CmdPeriod.run { ~endProgram };
	});


	w.front; // something safe to type on
	CmdPeriod.doOnce( ~endProgram );
};
);

Synth(\reverb3, [\in, 97]);
~buzzy_bram1 = Synth(\buzzy_bramm1, [\freq, 33, \out, 97]);
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