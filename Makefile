INSTALLDIR=/usr/local
DESTDIR=${INSTALLDIR}/genwebsite
JAR=${DESTDIR}/genwebsite.jar
LAUNCHER=genwebsite

install:
	mkdir -p ${DESTDIR}
	cp target/genwebsite-*.jar ${JAR}
	cp genwebsite.sh.mk ${LAUNCHER}.sh
	chmod +x ${LAUNCHER}.sh
	sed -i "" "s|DESTDIR|${JAR}|" ${LAUNCHER}.sh
	cp genwebsite.sh ${DESTDIR}
	ln -s ${DESTDIR}/${LAUNCHER}.sh ${INSTALLDIR}/bin/${LAUNCHER}

clean:
	rm -f ${LAUNCHER}.sh
	rm -f ${INSTALLDIR}/bin/${LAUNCHER}
	rm -rf ${DESTDIR}
