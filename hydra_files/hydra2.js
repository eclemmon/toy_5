osc(() => mouse.y ,() => mouse.x ,() => mouse.y * 2).color(() => mouse.y*2 ,() => mouse.x*5 ,() => mouse.y * 10)
.mult(osc(() => mouse.y ,() => mouse.x ,() => mouse.y * 2)).repeat(2, 20).rotate(0.5).modulate(o1)
.scale(1, () =>  (a.fft[0]*0.9 + 2)).diff(o1).out(o0)
osc(() => mouse.y ,() => mouse.x ,() => mouse.y * 2).color(() => mouse.y*10 ,() => mouse.x*10 ,() => mouse.y * 2).mult(osc(40)).modulateRotate(o0, 0.2)
.rotate(0.2).out(o1)
