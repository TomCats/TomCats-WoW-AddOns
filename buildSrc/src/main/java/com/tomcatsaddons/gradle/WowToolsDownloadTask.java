package com.tomcatsaddons.gradle;

import com.tomcatsaddons.wowtools.WowTools;
import com.tomcatsaddons.wowtools.WowToolsTable;
import org.apache.commons.io.FileUtils;
import org.gradle.api.DefaultTask;
import org.gradle.api.Project;
import org.gradle.api.tasks.TaskAction;

import java.io.File;
import java.io.IOException;
import java.net.URL;


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
        WowTools configuration = new WowTools(yamlFile, dbDir);
        for (WowToolsTable table : configuration.getTables()) {
            for (String locale : table.getLocales()) {
                File outputFile = table.getCachedFile(locale);
                if (!outputFile.exists()) {
                    URL url = table.getSourceURL(locale);
                    System.out.println(outputFile.toString() + " doesn't exist.  Downloading from: " + url.toString());
                    FileUtils.copyURLToFile(
                            url,
                            outputFile
                    );
                }
            }
        }
    }
}
