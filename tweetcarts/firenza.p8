pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- firenza, made on the train from rome to florence
-- unlike the demo, the train plodded through northern italy taking 3 and a half hours 
-- at least it gave a nice view of the scraggly hills and terracotta villas
--
-- just managed to finish reducing to the character limit before the laptop battery died
u=64e=128_set_fps(60)q=0poke(24404,96)t=e::a::t+=2z=rnd(1)x=cos(z)y=sin(z)sspr(x+5,y+5,118,118,-x,-y,e,e)if t>=e then
p=t~=e and{7,12,13,9,12}or{1,13,14,15}t=t==e and 1or 0circfill(u,u,8,p[1])end
for i=0,9do
q+=1a=q/450circ(u+9*cos(a),u+9*sin(a),1,p[flr(1+rnd(#p))])end
flip()goto a