-module(microservice_sup).

-behaviour(supervisor).

%% API
-export([start_link/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LocalPort,MaxInstances) ->
   io:format(" ~p~n",[{?MODULE,?LINE,LocalPort,MaxInstances}]),
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LocalPort,MaxInstances]).

init([LocalPort,MaxInstances]) ->
   io:format(" ~p~n",[{?MODULE,?LINE,LocalPort,MaxInstances}]),
    Server = {microservice, {microservice, start_link, [LocalPort,MaxInstances]},
              permanent, brutal_kill, worker, [microservice]},
   io:format(" ~p~n",[{?MODULE,?LINE,Server}]),
    Children = [Server],
    RestartStrategy = {one_for_one, 0, 1},
    {ok, {RestartStrategy, Children}}.
