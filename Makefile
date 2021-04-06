APPNAME=hyde
INSTALLDIR=~
DESTDIR=${INSTALLDIR}/.${APPNAME}
JAR=${DESTDIR}/${APPNAME}.jar
LAUNCHER=${APPNAME}

dist:
	mvn package

env:
	@echo "APPNAME    = "${APPNAME}
	@echo "INSTALLDIR = "${INSTALLDIR}
	@echo "DESTDIR    = "${DESTDIR}
	@echo "JAR        = "${JAR}
	@echo "LAUNCHER   = "${LAUNCHER}

install:
	mkdir -p ${DESTDIR}
	cp target/${APPNAME}-*-jar-with-dependencies.jar ${JAR}
	cp ${APPNAME}.sh.mk ${LAUNCHER}.sh
	chmod +x ${LAUNCHER}.sh
	sed -i "" "s|DESTDIR|${JAR}|" ${LAUNCHER}.sh
	cp ${APPNAME}.sh ${DESTDIR}
	ln -s ${DESTDIR}/${LAUNCHER}.sh ${INSTALLDIR}/bin/${LAUNCHER}

clean:
	rm -f ${LAUNCHER}.sh
	rm -f ${INSTALLDIR}/bin/${LAUNCHER}
	rm -rf ${DESTDIR}
