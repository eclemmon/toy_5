// Initializes window that captures key presses and displays key state changes as a 'confirmation' that a key has been entered.
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
	~scope.server = s;
	~scope.start;
	~scope.style = 1;
	~scope.yZoom = 20;
	~scope.xZoom = 1;
	~bus_scope_synth.setCycle(4096);
	~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];

	// Next Line
	compView.decorator.nextLine;

	// Build Progressbar
	~progressBar = Array.fill(~urprog.size * 4, {arg i;
		StaticText(compView, (compView.bounds.width - 300) / (~urprog.size * 4)@40).background_(Color.gray(gray: 1, alpha: 0.2));
	});

	// Quit Button
	quitButton = Button(compView, 200@40)
	.states_([["QUIT", Color.blue(alpha: 0.5), Color.green(alpha: 0.2)]])
	.font_(Font("Impact", 30))
	.action_({
		arg butt;
		CmdPeriod.run { ~endProgram };
	});

	~klank = Synth(\hermannKlank);
	~klankOn = False;
	~klankAmp = 0;
	w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
		~scope.waveColors = [Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9), Color.rand(lo:0.3, hi:0.9)];
		// turn on off
		if ((keycode == 36), {
			if ((~klankOn == False), {
				~klankAmp = 0.5;
				~klank.set(\amp, ~klankAmp);
				~klankOn = True;
			}, {
				~klankAmp = 0;
				~klank.set(\amp, ~klankAmp);
				~klankOn = False;
			});
		});

		if ((keycode == 47), {
			if ((~klankAmp <= 0.7), {
				~klankAmp = ~klankAmp + 0.05;
				~klank.set(\amp, ~klankAmp);
				~klankOn = True;
			});
		});

		if ((keycode == 43), {
			if ((~klankAmp > 0 && ~klankOn == True), {
				~klankAmp = ~klankAmp - 0.05;
				~klank.set(\amp, ~klankAmp);
				~klankAmp.postln;
				if ((~klankAmp < 0.001), {
					~klankAmp = 0;
					~klank.set(\amp, ~klankAmp);
					~klankOn = False;
				});
			});
		});
		};

	w.view.keyUpAction = {w.background = Color.gray};
	w.front; // something safe to type on
	// w.fullScreen; // COMMENT THIS IN IF YOU HAVE A DUAL MONITOR SET UP
	CmdPeriod.doOnce(~endProgram);
};

);

