
n = 50;

func = () => osc(30,0.0,1).modulate(noise(4,0))

pix = () => shape(4,0.3,0).scale(1,1,3).repeat(n,n)

pix().mult(func().color(1,0,0).pixelate(n,n)).out(o1)

pix().mult(func().color(0,1,0).pixelate(n,n)).scrollX(1/n/3).out(o2)

pix().mult(func().color(0,0,1).pixelate(n,n)).scrollX(2/n/3).out(o3)



// s0.initScreen()

s0.initCam()

src(s0).add(osc(10,0.1,100)).add(src(o1),1).add(src(o2),1).add(src(o3),1).out(o0)

​

// osc(15,0.1,5).add(src(o1),1).add(src(o2),1).add(src(o3),1).out(o0)

​

​

​

​

>>
