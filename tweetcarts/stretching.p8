pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- stretching, made on the train from london home
cls(0)_set_fps(60)poke(0x5f54, 0x60)t=0::a::t+=1k=sin(t/150)sspr(k,k,128-2*k,128-2*k,0,0,128,128)for i=0,32do
circ(rnd(128),rnd(128),0.5+rnd(3),1+rnd(3))end
flip()goto a
