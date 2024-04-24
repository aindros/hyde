#!/bin/sh

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

copy='Copyright \(C\).*Alessandro Iezzi.*'
newcopy="Copyright (C) 2022-`date +%Y`  Alessandro Iezzi <aiezzi AT alessandroiezzi DOT it>"

# The space before $copy is needed because sed must replace only the above
# copyright.
files=`grep -srE " $copy" * | sed 's/:.*//' | sort | uniq`

case `uname` in
	Linux)
		for i in $files; do
			sed -i'' -E "s/ $copy/ $newcopy/" $i
		done
	;;
	FreeBSD)
		for i in $files; do
			sed -i '' -E "s/ $copy/ $newcopy/" $i
		done
	;;
esac

