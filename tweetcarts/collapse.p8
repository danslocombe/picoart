pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
_set_fps(60)q=128poke(0x5f54,0x60)t=0p={1,13,14}::a::t+=1k=12*sin(t/200)-3if k>0then
pal(13,8)pal(14,9)sspr(k,k,q-2*k,q-2*k,0,0,q,q)pal()else
a=rnd()x=0.2*cos(a)y=0.2*sin(a)sspr(x,y,q,q,-x,-y,q,q)end
for i=0,80do
c=p[flr(1+rnd(3))]circ(rnd(q),rnd(q),0.2+rnd(3),c)end
flip()goto a

