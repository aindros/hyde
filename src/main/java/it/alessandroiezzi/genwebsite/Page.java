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

import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.ast.Node;
import com.vladsch.flexmark.util.data.MutableDataSet;
import lombok.Getter;
import lombok.Setter;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Page {
    @Setter private String rootDir = "";
    @Getter @Setter private String out = "";
    @Getter @Setter private String content = "";
    @Getter @Setter private String in = "";
    @Getter @Setter private String template = "";
    @Getter @Setter private String title = "";

    public String parse() throws IOException {
        if (content != null && !content.isEmpty()) {
            return content;
        } else if (in != null && !in.isEmpty() && !in.trim().isEmpty()) {
            String[] splited = in.split("\\.");
            String extension = splited[splited.length - 1];
            switch (extension) {
                case "md":
                    StringBuilder sb = new StringBuilder();
                    BufferedReader br = Files.newBufferedReader(Paths.get(rootDir).resolve(in));
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line).append("\n");
                    }


                    MutableDataSet options = new MutableDataSet();

                    // uncomment to set optional extensions
                    //options.set(Parser.EXTENSIONS, Arrays.asList(TablesExtension.create(), StrikethroughExtension.create()));

                    // uncomment to convert soft-breaks to hard breaks
                    //options.set(HtmlRenderer.SOFT_BREAK, "<br />\n");

                    Parser parser = Parser.builder(options).build();
                    HtmlRenderer renderer = HtmlRenderer.builder(options).build();

                    // You can re-use parser and renderer instances
                    Node document = parser.parse(sb.toString());

                    return renderer.render(document);
            }
        }

        return "";
    }
}
