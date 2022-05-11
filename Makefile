#PREFIX = /usr/local
PREFIX = ~

APPNAME = hyde
INSTALLDIR = ${PREFIX}/hyde
BINDIR     = ${PREFIX}/bin

SOURCES    != find * -type f -name "*.rb"

install:
	mkdir -p ${INSTALLDIR}
	chmod +x ${APPNAME}
	cp -f ${SOURCES} ${INSTALLDIR}/
	cp -f ${APPNAME} ${BINDIR}/
	sed -i '' "s|%INSTALLDIR%|${INSTALLDIR}|" ${BINDIR}/${APPNAME}
	sed -i '' "s|%APPNAME%|${APPNAME}.rb|" ${BINDIR}/${APPNAME}

clean:
	rm -rf ${INSTALLDIR}
	rm -f ${BINDIR}/${APPNAME}

~/bin/hyde: hyde.rb
	cp ${.ALLSRC} ${.TARGET}
