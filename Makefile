# A static website generator
# Copyright (C) 2022-2024  Alessandro Iezzi <aiezzi AT alessandroiezzi DOT it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

update-copyright:
	scripts/update-copiright.sh
