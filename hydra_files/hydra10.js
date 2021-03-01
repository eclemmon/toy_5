// open this link in your web browser first
// https://upload.wikimedia.org/wikipedia/commons/d/d5/Unknown_engraver_-_Humani_Victus_Instrumenta_-_Ars_Coquinaria_-_WGA23954.jpg

s0.initVideo("/Users/ericlemmon/Desktop/web_walking/updatedweb_walk.mp4")

a.show()
a.setBins(6)
a.fft[0]

src(s0)
  .diff(osc(0))
  .out(o0)
osc(0, 0, 0).diff(o0).out(o1)
voronoi(3,6,0.01).diff(o2).out(o3)
render(o3)
speed = 0.2
