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

import com.fasterxml.jackson.dataformat.xml.XmlMapper;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.apache.commons.cli.*;

import org.apache.commons.io.FileUtils;

import org.apache.commons.lang3.StringUtils;

import java.io.*;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Genwebsite {
    public static void main(String[] args) throws ParseException, IOException {
        String filename = "./website.xml";

        String longOpt = "file";
        Options options = new Options();
        Option _option = new Option("f", longOpt, true,
                                    "If your website descriptor has a differnt name or resides in other directory.");
        _option.setRequired(false);
        options.addOption(_option);
        CommandLine commandLine = new DefaultParser().parse(options, args);
        if (commandLine.hasOption(longOpt)) {
            filename = commandLine.getOptionValue(longOpt);
        }

        File websiteXml = Paths.get(filename).toFile();

        XmlMapper xmlMapper = new XmlMapper();
        Website website = xmlMapper.readValue(websiteXml, Website.class);
        // Where to build
        String websiteDir = websiteXml.getAbsoluteFile().getParent();
        if (website.getRootDir() == null || website.getRootDir().isEmpty()) {
            website.setRootDir(websiteDir);
        }
        System.out.println("Root dir is: " + website.getRootDir());
        File outDir = Paths.get(websiteDir).resolve("build").toFile();
        outDir.mkdirs();

        for (Dir dir : website.getIncludes()) {
            FileUtils.copyDirectory(new File(dir.getName()), Paths.get(outDir.toURI()).resolve(new File(dir.getName()).getName()).toFile());
        }

        //Freemarker configuration object
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_29);
        cfg.setDirectoryForTemplateLoading(new File(website.getRootDir()));
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        cfg.setLogTemplateExceptions(false);
        cfg.setWrapUncheckedExceptions(true);
        cfg.setFallbackOnNullLoopVariable(false);

        try {
            for (Page page : website.getPages()) {
                String pageTemplate = website.getTemplate();
                List<File> files = new ArrayList<>();

                if (page.getIn() != null && !page.getIn().isEmpty()) {
                    File file = new File(page.getIn());
                    if (file.isDirectory()) {
                        listf(page.getIn(), files);
                    } else {
                        files.add(new File(page.getIn()));
                    }
                }

                String pageOut = page.getOut();

                for (File curFile : files) {
                    System.out.println("Processing: " + curFile.getPath());
                    page.setIn(curFile.getPath());
                    page.parse();
                    if (StringUtils.isNotBlank(page.getTemplate())) {
                        pageTemplate = page.getTemplate();
                    }

                    //Load template from source folder
                    Template template = cfg.getTemplate(pageTemplate);

                    // Build the data-model
                    Map<String, Object> data = new HashMap<>();
                    data.put("title", page.getTitle());
                    data.put("date", page.getDate());
                    System.out.println(page.getDate() + " " + page.getTitle());
                    data.put("content", page.getContent());
                    data.put("globals", website.getGlobals());
                    data.put(page.getId() + "Active", "class=\"active\"");

                    // Console output
                    /*
                    Writer out = new OutputStreamWriter(System.out);
                    template.process(data, out);
                    out.flush();
                     */

                    if (pageOut == null || pageOut.isEmpty()) {
                        page.setOut(curFile.getPath().replace(".md", ".html"));
                        System.out.println("Out dir page: " + page.getOut());
                    }
                    File pageFile = Paths.get(outDir.getAbsolutePath()).resolve(page.getOut()).toFile();
                    pageFile.getParentFile().mkdirs();
                    if (pageFile.isDirectory()) {
                        pageFile = Paths.get(pageFile.getPath()).resolve(page.getIn()).toFile();
                    }

                    // File output
                    Writer file = new FileWriter(pageFile);
                    template.process(data, file);
                    file.flush();
                    file.close();
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        }
    }

    public static void listf(String directoryName, List<File> files) {
        File directory = new File(directoryName);

        // Get all files from a directory.
        File[] fList = directory.listFiles();
        if(fList != null) {
            for (File file : fList) {
                if (file.isFile()) {
                    files.add(file);
                } else if (file.isDirectory()) {
                    listf(file.getPath(), files);
                }
            }
        }
    }
}
