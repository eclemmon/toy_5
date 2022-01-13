// by Olivia Jack
// https://ojack.github.io
// Further love by Eric Lemmon
// https://ericlemmon.net

a.show()
a.setBins(5)

s0.initCam()

src(s0).out(o0)

osc(6, 0, 0.8)
    .color(() => 1.14 + a.fft[2] * 2, () => 0.5 + a.fft[3] * 0.5, () => 0.1 + a.fft[4])
    .rotate(() => 0.1 + a.fft[1], 0.3 +a.fft[2])
    .pixelate(a.fft[0] * 20 + 20, a.fft[0] * 10 + 10)
    .mult(osc(40, 0.03).thresh(0.4).rotate(0, -0.02))
    .modulateRotate(osc(20, 0).thresh(0.3, 0.6), () => 0.1 + a.fft[0] * 1.5)
    .blend(o0)
    .out(o1)

render(o1)

