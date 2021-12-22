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
    @Getter private String in = "";
    @Getter @Setter private String template = "";
    @Setter private String title = "";
    @Getter @Setter private String id = "";
    @Getter @Setter private String dir = "";
    @Getter private boolean parsed = false;
    @Getter private String date;

    public Page() {
        date = new String("");
    }

    public String getTitle() {
        if (!parsed) {
            throw new RuntimeException("You must call parse before getTitle");
        }

        System.out.println("Page title: " + title);

        return title;
    }

    public void setIn(String in) {
        parsed = false;
        this.in = in;
    }

    public void setDate(String date) {
        this.date = date;
        System.out.println("-------------------> " + date);
    }

    public String parse() throws IOException {
        if (parsed)
            return content;

        if (in != null && !in.isEmpty() && !in.trim().isEmpty()) {
            String[] splited = in.split("\\.");
            String extension = splited[splited.length - 1];

            StringBuilder sb = new StringBuilder();
            BufferedReader br = Files.newBufferedReader(Paths.get(rootDir).resolve(in));
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("# property:")) {
                    String property = line.replace("# property:", "");
                    String[] splitted = property.split("=");
                    if (splitted.length > 1) {
                        switch(splitted[0].trim()) {
                            case "title":
                                title = splitted[1].trim();
                                break;
                            case "date":
                                date = splitted[1].trim();
                                break;
                        }
                    }
                } else {
                    sb.append(line).append("\n");
                }
            }

            switch (extension) {
                case "md":
                    System.out.println("Parsing markdown");
                    MutableDataSet options = new MutableDataSet();

                    // uncomment to set optional extensions
                    //options.set(Parser.EXTENSIONS, Arrays.asList(TablesExtension.create(), StrikethroughExtension.create()));

                    // uncomment to convert soft-breaks to hard breaks
                    //options.set(HtmlRenderer.SOFT_BREAK, "<br />\n");

                    Parser parser = Parser.builder(options).build();
                    HtmlRenderer renderer = HtmlRenderer.builder(options).build();

                    // You can re-use parser and renderer instances
                    Node document = parser.parse(sb.toString());

                    content = renderer.render(document);
                    break;
                case "html":
                case "htm":
                case "xhtm":
                    content = sb.toString();
                    break;
            }
        }

        parsed = true;

        return content;
    }
}
