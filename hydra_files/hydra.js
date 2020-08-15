

noise(() => mouse.y ,() => mouse.x ,() => mouse.y * 2)
.rotate(100,-20,-30).mask(shape(10))
.colorama(2)
.modulateScale(o0, () => mouse.x * 0.002)
.modulateScale(o0,() => mouse.x * 0.001,)
.blend(o0)
.blend(o0)
.blend(o0)
.blend(o0)
.out(o0)
