%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : 
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_microservice).
%% --------------------------------------------------------------------
%% Include files 
%% --------------------------------------------------------------------
%%  -include("").
%-include_lib("eunit/include/eunit.hrl").
-include("../src/tcp.hrl").
-include("../src/dns.hrl").
%% --------------------------------------------------------------------
-compile(export_all).
%-export([test]).

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: Application
%% Description:
%% Returns: non
%% ------------------------------------------------------------------
%test()->
 %   R1=rpc:call(node(),test_adder,start_test,[],5000),
  %  io:format("~p~n",[{?MODULE,?LINE,R1}]),
   % R2=rpc:call(node(),test_adder,stop_test,[],5000),
   % io:format("~p~n",[{?MODULE,?LINE,R2}]),
   % ok.
%% --------------------------------------------------------------------
%% 1. Initial set up
%% --------------------------------------------------------------------


start()->
    {ok,ok}=microservice:boot(2).
%% Build and release a service and application josca

stop_test()->    
    %spawn(fun()->kill_session() end),
    ok.
kill_session()->
    timer:sleep(1000),
    erlang:halt(),
    ok.
  
    
