#!/usr/bin/make
#

.PHONY: test clean cleanall

pybot_options = 

all: test

bin/python:
	virtualenv-2.6 --distribute --no-site-packages .

develop-eggs: bin/python bootstrap.py
	./bin/python bootstrap.py

bin/buildout: develop-eggs

bin/test: buildout.cfg bin/buildout 
	./bin/buildout -Nvt 5
	touch $@

bin/instance: buildout.cfg bin/buildout 
	./bin/buildout -Nvt 5
	touch $@

bin/pybot: pybot.cfg buildout.cfg bin/buildout 
	./bin/buildout -Nvt 5 -c pybot.cfg
	touch $@

test: bin/test
	bin/test 

pybot: bin/pybot bin/instance
	bin/instance start
	bin/pybot $(pybot_options) acceptance-tests
	bin/instance stop

cleanall:
	rm -fr bin develop-eggs downloads eggs parts .installed.cfg
