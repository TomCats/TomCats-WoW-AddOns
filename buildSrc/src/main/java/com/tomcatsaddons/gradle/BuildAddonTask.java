package com.tomcatsaddons.gradle;

import org.apache.commons.io.FileUtils;
import org.gradle.api.DefaultTask;
import org.gradle.api.tasks.TaskAction;

import java.io.File;
import java.io.IOException;

public class BuildAddonTask extends DefaultTask {

    public String game;
    public String[] includeFrom;
    public File sourceDir;
    public File outputDir;

    @TaskAction
    public void build() throws IOException {
        FileUtils.deleteDirectory(outputDir);
        FileUtils.forceMkdir(outputDir);
        // mock build
        if (includeFrom != null) {
            for(String include : includeFrom) {
                File includeDir = new File(sourceDir.getParentFile(), include);
                FileUtils.copyDirectory(includeDir, outputDir, true);
            }
        }
        FileUtils.copyDirectory(sourceDir, outputDir, true);
    }

}
