%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : genserver repo with jle embedded extensions 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(repo).

-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("include/repository_data.hrl").
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Definitions
%% --------------------------------------------------------------------
% -define(DEFINE,define).
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Data structures
%% --------------------------------------------------------------------
-record(state, {dbase_id}).

%% --------------------------------------------------------------------



%% External exports
-export([build_artifact/2,update_artifact/1,read_artifact/2
	 %all_artifacts/1,
	 %delete_artifact/2
	]).



-export([start/0,stop/0]).
%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).



%% ====================================================================
%% External functions
%% ====================================================================
start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).



build_artifact(ServiceId,EbinDir)->
    gen_server:call(?MODULE, {build_artifact,ServiceId,EbinDir},infinity).

update_artifact(Artifact)->
    gen_server:call(?MODULE, {update_artifact,Artifact},infinity).
read_artifact(ServiceId,Vsn)-> 
    gen_server:call(?MODULE, {read_artifact,ServiceId,Vsn},infinity).

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    Type=set,
    DbaseId="repository.dbase",
    dbase_dets:create_dbase(Type,DbaseId),
    
    io:format("Starting ~p~n",[{?MODULE}]),
    {ok, #state{dbase_id=DbaseId}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({build_artifact,ServiceId,EbinDir}, _From, State) ->
    Reply=rpc:call(node(),repo_lib,build_artifact,[ServiceId,EbinDir]),
    {reply, Reply, State};

handle_call({update_artifact,Artifact}, _From, State) ->
    DbaseId=State#state.dbase_id,
    Reply=rpc:call(node(),repo_lib,update_artifact,[Artifact,DbaseId]),
    {reply, Reply, State};

handle_call({read_artifact,ServiceId,Vsn}, _From, State) ->
    DbaseId=State#state.dbase_id,
    Reply=rpc:call(node(),repo_lib,read_artifact,[ServiceId,Vsn,DbaseId]),
    {reply, Reply, State};

handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.
 
%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{Msg,?MODULE,time()}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
