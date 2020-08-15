// Hydra code by
// 3.3
// by ΔNDR0M3DΔ
// https://www.instagram.com/androm3_da/
// Further mods by @eriiccomposer

osc().modulateRotate(o0, () => (mouse.y * 0.01)+0.75).out()
osc(() => mouse.x-1.9999, 3, 1).diff(o3,0.01).out(o1)
osc(() => mouse.x-1.9999, 3, 1).modulateKaleid(o3,3).diff(o0).out(o2)
src(o0,3).mult(o1,3).kaleid(3).out(o3)
render(o2)
