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
	~scope.style = 0;
	~scope.yZoom = 5;
	~bus_scope_synth.setCycle(1024);
	w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
		~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];
		};
	w.view.keyUpAction = {w.background = Color.gray};

	// Next Line
	compView.decorator.nextLine;

	// Build Progressbar
	~progressBar = Array.fill(~urprog.size * 3, {arg i;
		StaticText(compView, (compView.bounds.width - 300) / (~urprog.size * 3)@90).background_(Color.gray(gray: 1, alpha: 0.2));
	});

	// Quit Button
	quitButton = Button(compView, 200@90)
	.states_([["QUIT", Color.blue(alpha: 0.5), Color.green(alpha: 0.2)]])
	.font_(Font("Impact", 30))
	.action_({
		arg butt;
		CmdPeriod.run { ~endProgram };
	});

	// Build Synths
	~moonlanderbuf = Buffer.read(s, ~cwd ++ "/granulation/samples/a11wlk01-44_1.aiff");
	~helicopterbuf = Buffer.readChannel(s, ~cwd ++ "/granulation/samples/helicopter.wav", 0, channels: [0]);

	Synth(\low_creepy_granulation, [\out, 0, \gate, 1, \amp, 0.5, \sndbuf, ~moonlanderbuf, \grainSize, 0.5, \freq, 40, \trigRate, 20, \maxRate, 0.001]);
	Synth(\buf_grain_test, [\sndbuf, ~helicopterbuf, \envbuf, -1, \out, 0]);

	w.front; // something safe to type on

	CmdPeriod.doOnce(~endProgram);
};

);