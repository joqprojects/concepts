%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : 
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_template).
%% --------------------------------------------------------------------
%% Include files 
%% --------------------------------------------------------------------
%%  -include("").
-include_lib("eunit/include/eunit.hrl").
-include("include/repository_data.hrl").
%% --------------------------------------------------------------------
%-export([start/0]).
-export([]).

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: Application
%% Description:
%% Returns: non
%% ------------------------------------------------------------------

%% --------------------------------------------------------------------
%% 1. Initial set up
start_test()->
    ok=application:start(template),   
    ok.

build_100_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.0/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.0",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
    ok.

update_100_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.0/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.0",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
     {ok,artifact_updated}=template:update_artifact(Artifact),
    ok.

read_100_test()->
    Artifact=template:read_artifact("template","1.0.0"),
    #artifact{service_id="template",
	      vsn="1.0.0",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
    ok.
%------------------- 
build_101_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.1/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.1",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
    ok.

update_101_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.1/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.1",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
     {ok,artifact_updated}=template:update_artifact(Artifact),
    ok.

read_100_1_test()->
    #artifact{service_id="template",
	      vsn="1.0.0",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.0"),
    ok.
read_101_0_test()->
    #artifact{service_id="template",
	      vsn="1.0.1",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.1"),
    ok.
read_latest_101_100_test()->
    #artifact{service_id="template",
	      vsn="1.0.1",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template",latest),

    ok.
%-------------------
build_103_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.3/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.3",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
    ok.

update_103_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.3/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.3",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
     {ok,artifact_updated}=template:update_artifact(Artifact),
    ok.

read_100_2_test()->
    #artifact{service_id="template",
	      vsn="1.0.0",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.0"),
    ok.
read_101_1_test()->
    #artifact{service_id="template",
	      vsn="1.0.1",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.1"),
    ok.

read_103_0_test()->
    #artifact{service_id="template",
	      vsn="1.0.3",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.3"),
    ok.
read_latest_103_101_100_test()->
    #artifact{service_id="template",
	      vsn="1.0.3",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template",latest),

    ok.

%-------------------
build_102_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.2/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.2",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
    ok.

update_102_test()->
    {ok,Artifact}=template:build_artifact("template","template_1.0.2/ebin"),
    #artifact{service_id="template",
	      vsn="1.0.2",
	      appfile={"template.app",_},
	      modules=_}=Artifact,
     {ok,artifact_updated}=template:update_artifact(Artifact),
    ok.

read_100_3_test()->
    #artifact{service_id="template",
	      vsn="1.0.0",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.0"),
    ok.
read_101_2_test()->
    #artifact{service_id="template",
	      vsn="1.0.1",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.1"),
    ok.

read_103_1_test()->
    #artifact{service_id="template",
	      vsn="1.0.3",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.3"),
    ok.

read_102_0_test()->
    #artifact{service_id="template",
	      vsn="1.0.2",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template","1.0.2"),
    ok.

read_latest_102_103_101_100_test()->
    #artifact{service_id="template",
	      vsn="1.0.3",
	      appfile={"template.app",_},
	      modules=_}=template:read_artifact("template",latest),

    ok.

stop_test()->  
    file:delete("repository.dbase"),
    ok=application:stop(template),
    spawn(fun()->kill_session() end),
    ok.
kill_session()->
    timer:sleep(1000),
    erlang:halt(),
    ok.
    
