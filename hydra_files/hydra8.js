// disintegration
// by Ritchse
// instagram.com/ritchse
// cam & pixellation added by @ericcomposer

s0.initCam()

src(s0).pixelate(()=>mouse.x,()=>mouse.y).add(osc(5,.1).modulate(noise(6),.22).diff(o0)
  	.modulateScrollY(osc(2).modulate(osc().rotate(),.11))
	.scale(.72).color(0.99,1.014,1))
  	.out()
