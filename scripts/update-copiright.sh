#!/bin/sh

for i in `grep -sE 'Copyright \(C\) 2022.*' * | sed 's/:.*//'`; do
	sed -E "s/Copyright \(C\) 2022.*/Copyright (C) 2022-`date +%Y`  Alessandro Iezzi <aiezzi AT alessandroiezzi DOT it>/"
done

