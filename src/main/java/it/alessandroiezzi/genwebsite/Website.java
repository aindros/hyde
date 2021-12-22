/*
 * Copyright (C) 2021  Alessandro Iezzi dev@alessandroiezzi.it
 *
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
package it.alessandroiezzi.genwebsite;

import lombok.Getter;
import lombok.Setter;
import org.apache.commons.lang3.StringUtils;

import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class Website {
    @Getter private List<Dir> includes = new ArrayList<>();
    @Getter private String rootDir;
    @Setter private String pagesDir;
    @Getter @Setter private String template;
    @Getter @Setter private List<Page> pages = new ArrayList<>();
    @Getter private Map<String, String> globals = new HashMap<>();

    public void setRootDir(String rootDir) {
        this.pages.forEach(p -> {
            String rootPageDir = rootDir;
            if (StringUtils.isNotBlank(pagesDir)) {
                rootPageDir = Paths.get(rootDir).resolve(pagesDir).toFile().getAbsolutePath();
            }
            p.setRootDir(rootPageDir);
        });
        this.rootDir = rootDir;
    }
}
