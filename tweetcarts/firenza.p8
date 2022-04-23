pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
u=64e=128l=circfill
_set_fps(60)poke(0x5f54,0x60)t=127p={}q=0::a::t+=1z=rnd(1)x=cos(z)y=sin(z)sspr(x+5,y+5,118,118,-x,-y,e,e)
for i=0,9do
q+=1a=q/450circ(u+10*cos(a),u+10*sin(a),1+rnd(1),p[flr(1+rnd(#p))])end
if t==e then
p={7,12,13}l(u,u,8,p[1])elseif t>250then
p={1,13,14,15}l(u,u,8,p[1])t=0end
flip()goto a