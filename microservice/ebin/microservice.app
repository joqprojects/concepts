{application, microservice,
 [{description, "template for jle microservice"},
  {vsn, "0.1.0"},
  {modules, [adder,divider,
  	    microservice_app,
             microservice_sup,
	     microservice]},
  {registered, [microservice]},
  {applications, [kernel, stdlib]},
  {mod, {microservice_app, []}}
 ]}.
