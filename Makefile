INSTALLDIR=/usr/local
DESTDIR=${INSTALLDIR}/genwebsite
JAR=${DESTDIR}/genwebsite.jar
LAUNCHER=genwebsite
BUILDDIR=target

dist:
	mvn package
	cp genwebsite.sh.mk ${BUILDDIR}/${LAUNCHER}.sh
	chmod +x ${BUILDDIR}/${LAUNCHER}.sh
	sed -i "" "s|DESTDIR|${JAR}|" ${BUILDDIR}/${LAUNCHER}.sh

install:
	mkdir -p ${DESTDIR}
	cp target/genwebsite-*-jar-with-dependencies.jar ${JAR}
	cp ${BUILDDIR}/${LAUNCHER}.sh ${DESTDIR}
	ln -s -f ${DESTDIR}/${LAUNCHER}.sh ${INSTALLDIR}/bin/${LAUNCHER}

clean:
	rm -rf ${BUILDDIR}
	rm -f ${INSTALLDIR}/bin/${LAUNCHER}
	rm -rf ${DESTDIR}
