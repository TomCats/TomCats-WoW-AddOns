package com.tomcatsaddons.gradle;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.gradle.api.DefaultTask;
import org.gradle.api.Project;
import org.gradle.api.tasks.TaskAction;
import org.yaml.snakeyaml.Yaml;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Map;

public class WowToolsDownloadTask extends DefaultTask {

    @SuppressWarnings("rawtypes")
    @TaskAction
    public void download() throws IOException {
        Project project = getProject();
        File projectDir = project.getProjectDir();
        File buildDir = project.getBuildDir();
        File dbDir = new File(buildDir, "db");
        if (!dbDir.exists()) {
            //noinspection ResultOfMethodCallIgnored
            dbDir.mkdirs();
        }
        File yamlFile = new File(projectDir,"wowtools.yml");
        Yaml yaml = new Yaml();
        Map cfg = yaml.load(new FileInputStream(yamlFile));
        Map databases = (Map)cfg.get("databases");
        String[] defaultLocale = new String[] { (String)cfg.get("locale-default") };
        String[] allLocales = ((String)cfg.get("locales")).split(",");
        String urlPattern = (String)cfg.get("url");
        String filenamePattern = "${table}-${build}-${locale}.csv";
        String[] tokens = new String[] { "${table}", "${build}", "${locale}" };
        for (Object database : databases.values()) {
            Map database1 = (Map) database;
            String build = (String)database1.get("build");
            Map tables = (Map)database1.get("tables");
            for (Object table : tables.entrySet()) {
                Map.Entry table1 = (Map.Entry) table;
                String tableName = (String)table1.getKey();
                Map tableProps = (Map)table1.getValue();
                String localesValue = (String)tableProps.get("locales");
                String[] locales;
                if (localesValue.equals("all")) {
                    locales = allLocales;
                } else if (localesValue.equals("default")) {
                    locales = defaultLocale;
                } else {
                    locales = localesValue.split(",");
                }
                for(String locale : locales) {
                    String[] params = new String[] { tableName, build, locale};
                    String filename = StringUtils.replaceEach(
                            filenamePattern,
                            tokens,
                            params
                    );
                    File outputFile = new File(dbDir, filename);
                    if (!outputFile.exists()) {
                        String url = StringUtils.replaceEach(
                                urlPattern,
                                tokens,
                                params
                        );
                        System.out.println(filename + " doesn't exist.  Downloading from: " + url);
                        FileUtils.copyURLToFile(
                                new URL(url),
                                outputFile
                        );
                    }
                }
            }
        }
    }
}
