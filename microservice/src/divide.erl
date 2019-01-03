-module(divide).

-export([divi/2]).

divi(A,B)->
  %  io:format("rev 1.0.0 ~n"),
    Reply= case B of
	0->
	   {error,badarith,B};
	_->
	    A/B
    end,
    Reply.
