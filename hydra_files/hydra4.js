var myElement = document.createElement('img');
myElement.src = '/Users/ericlemmon/Desktop/371px-Unknown_engraver_-_Humani_Victus_Instrumenta_-_Ars_Coquinaria_-_WGA23954.jpg';

s0.init(
  {
    src: myElement ,
    dynamic: false
  }
);

src(s0)
  .pixelate(()=>mouse.x,()=>mouse.y)
  .diff(osc(0))
  .out(o0)
osc(0, 0, 0).diff(o0).out(o1)
osc(function(){return 3 * Math.sin(time * 0.1)}).kaleid(6).diff(o1).out(o2)
voronoi(5,5,0.01).diff(o2).out(o3)
render(o3)
speed = 0.2
