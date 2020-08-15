
noise( ({time}) => Math.sin(time/2)/500 , ({time}) => Math.sin(time/2)/500 )
    .mult(osc(0.1,0.25,1))
    .out(o0)
voronoi(10,2,1).diff(o0).out(o1)
voronoi(20,1,1).diff(o1).out(o2)
shape(()=>mouse.y/100+4, ()=>mouse.x/2500, 0.5).diff(o2).out(o3)
render(o3)
