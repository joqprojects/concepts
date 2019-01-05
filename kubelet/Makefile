## set the paths for a default setup
test_ms:
#	rm -rf */*~ *.beam */*.beam *~ *.dump;
	erlc -o ebin src/*.erl;
	erlc -o ebin test/*.erl;
	cp src/*.app ebin;
	erl -pa ebin -s test_microservice start -sname test_microservice
s1:
#	rm -rf ebin/adder.beam;
	erlc -o ebin adder1/*.erl
s2:
#	rm -rf ebin/adder.beam;
	erlc -o ebin adder2/*.erl
