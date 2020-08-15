var myElement = document.createElement('img');
myElement.src = '/Users/ericlemmon/Desktop/61177116841__C4B47E4A-7466-4043-A632-64643B668040.jpeg';

s0.init(
  {
    src: myElement, // variable that holds element
    dynamic: false   // set true for video
  }
);

src(s0)
  .rotate(5)
  .pixelate(()=>mouse.x, 100)
  .kaleid(7)
  .diff(osc(12))
  .out(o0);
osc(0.1, 0.75, 1).diff(o0).out(o1)
osc(function(){return 3 * Math.sin(time * 0.1)}).kaleid(2).diff(o1).out(o2)
voronoi(10,3,2).diff(o2).rotate(2).out(o3)
render(o3);
