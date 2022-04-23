pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
u=64e=128l=circfill
_set_fps(60)poke(0x5f54,0x60)t=e q=0::a::t+=2z=rnd(1)x=cos(z)y=sin(z)sspr(x+5,y+5,118,118,-x,-y,e,e)
if t>=e then
p=t~=e and{7,12,13}or{1,13,14,15}t=t==e and 1or 0l(u,u,8,p[1])end
for i=0,9do
q+=1a=q/450circ(u+9*cos(a),u+9*sin(a),1,p[flr(1+rnd(#p))])end
flip()goto a