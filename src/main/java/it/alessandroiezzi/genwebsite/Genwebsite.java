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
        website.setRootDir(websiteXml.getAbsoluteFile().getParent());
        File outDir = Paths.get(website.getRootDir()).resolve("build").toFile();
        outDir.mkdirs();

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

                if (StringUtils.isNotBlank(page.getTemplate())) {
                    pageTemplate = page.getTemplate();
                }

                //Load template from source folder
                Template template = cfg.getTemplate(pageTemplate);

                // Build the data-model
                Map<String, Object> data = new HashMap<>();
                data.put("title", page.getTitle());
                data.put("content", page.parse());

                // Console output
                Writer out = new OutputStreamWriter(System.out);
                template.process(data, out);
                out.flush();

                File pageFile = Paths.get(outDir.getAbsolutePath()).resolve(page.getOut()).toFile();
                pageFile.getParentFile().mkdirs();

                // File output
                Writer file = new FileWriter(pageFile);
                template.process(data, file);
                file.flush();
                file.close();
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        }
    }
}
