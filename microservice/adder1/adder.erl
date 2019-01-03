-module(adder).

-export([add/2,sleep/1,vsn/0]).


sleep(T)->
	sleep(T*1000).

add(A,B)->
    A+B.
vsn()->
	1.
