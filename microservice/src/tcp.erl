%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Created : 7 March 2015
%%% Revsion : 2015-06-19: 1.0.0 :  Created
%%% Description :
%%% Generic tcp server interface to internet and "middle man". Concept 
%%% described in Joe Armstrong book
%%% -------------------------------------------------------------------
-module(tcp).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Definitions
%% --------------------------------------------------------------------
-include("tcp.hrl").
-include("cert.hrl").
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([call/5,call/6,call/3,cast/3,server_seq/1,server_parallel/1,par_connect/1,single/1]).


%%
%% API Function
%%

%% Sender part
call(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{os,cmd,A}})->
    call(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{?KEY_M_OS_CMD,?KEY_F_OS_CMD,A}},?KEY_MSG);

call(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{M,F,A}})->
    call(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{M,F,A}},?KEY_MSG).

call(AddrNfvi,PortNfvi,{CallingMode,{os,cmd,A}})->
    call(AddrNfvi,PortNfvi,{CallingMode,{?KEY_M_OS_CMD,?KEY_F_OS_CMD,A}},?KEY_MSG);

call(AddrNfvi,PortNfvi,{CallingMode,{M,F,A}})->
    call(AddrNfvi,PortNfvi,{CallingMode,{M,F,A}},?KEY_MSG).

call(Addr,Port,AddrService,PortService,{CallingMode,{M,F,A}},?KEY_MSG)->
    case {M,F} of
	{dns,register}->
%	    io:format(" ****************************************************~n"),
	  %  io:format(" DNS REgister  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	   % Result=send(Addr,Port,[AddrService,PortService,{dns,register,A},?KEY_MSG]),
	    Result=send(Addr,Port,[AddrService,PortService,{CallingMode,{dns,register,A}},?KEY_MSG]);
	   % io:format(" Dns  RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]);
	_->
	  %  io:format(" ****************************************************~n"),
	   % io:format(" CALL INSIGNAL  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	    Result=send(Addr,Port,[AddrService,PortService,{CallingMode,{M,F,A}},?KEY_MSG]),
	   % io:format(" CALL RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]),
	    Result
    end,	
    Result.

call(Addr,Port,{CallingMode,{M,F,A}},?KEY_MSG)->
 %   io:format(" CALL INSIGNAL  ~p~n",[{?MODULE,?LINE,Addr,Port,{M,F,A}}]),
    case {M,F} of
	{dns,register}->
	   % io:format(" ****************************************************~n"),
	   % io:format(" DNS REgister  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	  %  Result=send(Addr,Port,[{dns,register,A},?KEY_MSG]),
	    Result=send(Addr,Port,[{CallingMode,{dns,register,A}},?KEY_MSG]);
%	     io:format(" Dns RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]);
	_->
	 %   io:format(" ****************************************************~n"),
	  %  io:format(" CALL INSIGNAL  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	    Result=send(Addr,Port,[{CallingMode,{M,F,A}},?KEY_MSG]),
	   % io:format(" CALL RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]),
	    Result
    end,	
    Result.

send(Addr,Port,Msg)->
  %  io:format("send   ~p~n",[{?MODULE,?LINE,Addr,Port,Msg}]),
    case gen_tcp:connect(Addr,Port,?CLIENT_SETUP) of
	{ok,Socket}->
	  %  io:format("ok Socket  ~p~n",[{?MODULE,?LINE,Addr,Port,Msg,inet:socknames(Socket)}]),
	    ok=gen_tcp:send(Socket,term_to_binary(Msg)),
	    receive
		{tcp,Socket,Bin}->
		    Result=binary_to_term(Bin),
		    %io:format("send Result ~p~n",[{?MODULE,?LINE,Result,inet:socknames(Socket)}]),	    
		    gen_tcp:close(Socket);
		{error,Err} ->
		    io:format("send error ~p~n",[{?MODULE,?LINE,Err,Addr,Port,Msg}]),
		    Result={error,[?MODULE,?LINE,Err]},
		    gen_tcp:close(Socket)
	    after ?TIMEOUT_TCPCLIENT ->
		    io:format("send error ~p~n",[{?MODULE,?LINE,time_out,Addr,Port,Msg}]),
		    Result={error,[?MODULE,?LINE,tcp_timeout,Addr,Port,Msg]},
		    gen_tcp:close(Socket)
	    end;
	{error,Err} ->
	    io:format("send error ~p~n",[{?MODULE,?LINE,Err,Addr,Port,Msg}]),
	    Result={error,{Err,?MODULE,?LINE}}
    end,	
    Result.

%%---------------------------------------------------------------------------------------------------------------
cast(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{os,cmd,A}})->
    cast(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{?KEY_M_OS_CMD,?KEY_F_OS_CMD,A}},?KEY_MSG);

cast(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{M,F,A}})->
    cast(AddrNfvi,PortNfvi,AddrService,PortService,{CallingMode,{M,F,A}},?KEY_MSG).

cast(AddrNfvi,PortNfvi,{CallingMode,{os,cmd,A}})->
    cast(AddrNfvi,PortNfvi,{CallingMode,{?KEY_M_OS_CMD,?KEY_F_OS_CMD,A}},?KEY_MSG);

cast(AddrNfvi,PortNfvi,{CallingMode,{M,F,A}})->
    cast(AddrNfvi,PortNfvi,{CallingMode,{M,F,A}},?KEY_MSG).


cast(Addr,Port,AddrService,PortService,{CallingMode,{M,F,A}},?KEY_MSG)->
    case {M,F} of
	{dns,register}->
%	    io:format(" ****************************************************~n"),
	  %  io:format(" DNS REgister  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	   % Result=send(Addr,Port,[AddrService,PortService,{dns,register,A},?KEY_MSG]),
	    Result=send_cast(Addr,Port,[AddrService,PortService,{CallingMode,{dns,register,A}},?KEY_MSG]);
	   % io:format(" Dns  RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]);
	_->
	  %  io:format(" ****************************************************~n"),
	   % io:format(" CALL INSIGNAL  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	    Result=send_cast(Addr,Port,[AddrService,PortService,{CallingMode,{M,F,A}},?KEY_MSG]),
	   % io:format(" CALL RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]),
	    Result
    end,	
    Result.

cast(Addr,Port,{CallingMode,{M,F,A}},?KEY_MSG)->
 %   io:format(" CALL INSIGNAL  ~p~n",[{?MODULE,?LINE,Addr,Port,{M,F,A}}]),
    case {M,F} of
	{dns,register}->
	   % io:format(" ****************************************************~n"),
	   % io:format(" DNS REgister  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	  %  Result=send(Addr,Port,[{dns,register,A},?KEY_MSG]),
	    Result=send_cast(Addr,Port,[{CallingMode,{dns,register,A}},?KEY_MSG]);
%	     io:format(" Dns RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]);
	_->
	 %   io:format(" ****************************************************~n"),
	  %  io:format(" CALL INSIGNAL  ~p~n",[{?MODULE,?LINE,M,F,A}]),
	    Result=send_cast(Addr,Port,[{CallingMode,{M,F,A}},?KEY_MSG]),
	   % io:format(" CALL RESPONSE  ~p~n",[{?MODULE,?LINE,Result}]),
	    Result
    end,	
    Result.

send_cast(Addr,Port,Msg)->
  % io:format(" ~p~n",[{?MODULE,?LINE,Msg}]),
    case gen_tcp:connect(Addr,Port,?CLIENT_SETUP) of
	{ok,Socket}->
	    Result=ok,
	    ok=gen_tcp:send(Socket,term_to_binary(Msg));
 	    %gen_tcp:close(Socket);
%	    _Pid=spawn(fun()-> cast_local(Socket,Msg) end);
	{error,Err} ->
	    Result={error,{Err,?MODULE,?LINE}}
    end,	
    Result.  


% Receive part
%% --------------------------------------------------------------------
%% Function: fun/x
%% Description: fun x skeleton 
%% Returns:ok|error
%% ------------------------------------------------------------------
server_seq(Port)->
    {ok, LSock}=gen_tcp:listen(Port,?SERVER_SETUP),  
    seq_loop(LSock).

seq_loop(LSock)->
    {ok,Socket}=gen_tcp:accept(LSock),
    single(Socket),
    seq_loop(LSock).

%% --------------------------------------------------------------------
%% Function: fun/x
%% Description: fun x skeleton 
%% Returns:ok|error
%% ------------------------------------------------------------------
server_parallel(Port)->
    {ok, LSock}=gen_tcp:listen(Port,?SERVER_SETUP),
    spawn(fun()-> par_connect(LSock) end),
    receive
	wait_for_ever->
	    ok
    end.

par_connect(LSock)->
    {ok,Socket}=gen_tcp:accept(LSock),
    spawn(fun()-> par_connect(LSock) end),
    tcp:single(Socket).
%% --------------------------------------------------------------------
%% Function: fun/x
%% Description: fun x skeleton 
%% Returns:ok|error
%% ------------------------------------------------------------------
single(Socket)->
    receive
	{tcp, Socket, Bin} ->
%	    io:format("~p~n",[{node(),?MODULE,?LINE,binary_to_term(Bin),inet:socknames(Socket)}]),
	 %   ["localhost",20000,{dns,register,[A]},'100200273'],
	    case binary_to_term(Bin) of
	 % Nfvi part
		[AddrService,PortService,{dns,register,A},?KEY_MSG]->
		   % io:format("NFVI IN~p~n",[{node(),?MODULE,?LINE,binary_to_term(Bin),inet:socknames(Socket)}]),
		    Reply=tcp:call(AddrService,PortService,{dns,register,A}),
		  %  io:format("NFVI OUT~p~n",[{node(),?MODULE,?LINE,Reply,inet:socknames(Socket)}]),
		    gen_tcp:send(Socket, term_to_binary(Reply));
%		    tcp:loop(Socket);
		[AddrService,PortService,{M,F,A},?KEY_MSG]->
		  %  io:format("NFVI IN~p~n",[{node(),?MODULE,?LINE,binary_to_term(Bin),inet:socknames(Socket)}]),
		    Reply=tcp:call(AddrService,PortService,{M,F,A}),
		  %  io:format("NFVI OUT~p~n",[{node(),?MODULE,?LINE,Reply,inet:socknames(Socket)}]),
		    gen_tcp:send(Socket, term_to_binary(Reply));
		%    tcp:loop(Socket);
	% Service part	
		[{dns,register,A},?KEY_MSG]->
		  %  io:format("***************************************************************************~n"),
		  %  io:format("LOCAL IN~p~n",[{node(),?MODULE,?LINE,binary_to_term(Bin),inet:socknames(Socket)}]),
		    _R=action(Socket,{dns,register,A});
		   % io:format("LOCAL OUT~p~n",[{node(),?MODULE,?LINE,R,inet:socknames(Socket)}]),
		%    tcp:loop(Socket);

		[{vim,register,A},?KEY_MSG]->
		  %  io:format("***************************************************************************~n"),
		  %  io:format("LOCAL IN~p~n",[{node(),?MODULE,?LINE,binary_to_term(Bin),inet:socknames(Socket)}]),
		    _R=action(Socket,{vim,register,A});
		   % io:format("LOCAL OUT~p~n",[{node(),?MODULE,?LINE,R,inet:socknames(Socket)}]),
		 %   tcp:loop(Socket);
		[{M,F,A},?KEY_MSG]->
%		    io:format("***************************************************************************~n"),
%		    io:format("LOCAL IN~p~n",[{node(),?MODULE,?LINE,binary_to_term(Bin),inet:socknames(Socket)}]),
		    _R=action(Socket,{M,F,A});
%		    io:format("LOCAL OUT~p~n",[{node(),?MODULE,?LINE,R,inet:socknames(Socket)}]),
		    % tcp:loop(Socket);		
		{tcp_closed, Socket} ->
		    io:format("tcp_closed  ~p~n",[{node(),?MODULE,?LINE,Socket}]),
		    gen_tcp:close(Socket),	
		    tcp_closed;
		Err ->
		    io:format("error  ~p~n",[{node(),?MODULE,?LINE,Err,inet:socknames(Socket)}]),
		    gen_tcp:send(Socket, term_to_binary(Err))
		  %  tcp:loop(Socket)
	    end
    end.

action(Socket, {M,F,A})->
    Reply=case  {M,F,A} of
	      {?KEY_M_OS_CMD,?KEY_F_OS_CMD,A}->
		  R=case rpc:call(node(),erlang,apply,[os,cmd,A],?CALL_TIMEOUT) of
			{badrpc,Err}->
			    io:format("badrpc ~p~n",[{?MODULE,?LINE,Err,node(),os,cmd,A}]),
			    {error,[?MODULE,?LINE,Err,node(),os,cmd,A]};
			Result->
			    Result
		    end,
		  gen_tcp:send(Socket, term_to_binary(R)),
		  R;
	      {M,F,A}->
		%  io:format("{M,F,A} ~p~n",[{?MODULE,?LINE,node(),M,F,A}]),
	%	  R=case erlang:apply(M,F,A) of
		  R=case rpc:call(node(),erlang,apply,[M,F,A],?CALL_TIMEOUT) of
			{badrpc,Err}->
			    io:format("badrpc ~p~n",[{?MODULE,?LINE,M,F,A,Err,node()}]),
			    {error,[?MODULE,?LINE,Err,node(),M,F,A]};
			Result->
			    Result
		    end,
%		  io:format("RESPONSE  ~p~n",[{node(),?MODULE,?LINE,R}]),
		  gen_tcp:send(Socket, term_to_binary(R)),
		  R;	    
	      Err ->
		  io:format("unmatched signal  ~p~n",[{node(),?MODULE,?LINE,Err}]),
		  {error,[?MODULE,?LINE,Err,node()]}
	  end,  
    Reply.
    
