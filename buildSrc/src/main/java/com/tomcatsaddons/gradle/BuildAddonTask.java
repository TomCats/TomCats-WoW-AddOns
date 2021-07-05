package com.tomcatsaddons.gradle;

import com.tomcatsaddons.compressiontools.CompressionTools;
import com.tomcatsaddons.lua.LuaTools;
import com.tomcatsaddons.mvel.CSVTool;
import com.tomcatsaddons.mvel.DBTool;
import com.tomcatsaddons.mvel.StringTool;
import com.tomcatsaddons.mvel.TemplateTool;
import com.tomcatsaddons.wowtools.WowTools;
import org.apache.commons.io.FileUtils;
import org.gradle.api.DefaultTask;
import org.gradle.api.Project;
import org.gradle.api.tasks.TaskAction;
import org.mvel2.MVEL;
import org.mvel2.ParserContext;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Stream;

public class BuildAddonTask extends DefaultTask {

    public String game;
    public String[] includeFrom;
    public DBTool dbtool;
    public Properties tokens;

    private static ParserContext parserContext;

    private static ParserContext getParserContext() {
        if (parserContext == null) {
            ParserContext pctx = new ParserContext();
            pctx.addPackageImport("java.util");
            pctx.addPackageImport("java.io");
            pctx.addImport(StandardCharsets.class);
            pctx.addImport(FileUtils.class);
            pctx.addImport(LuaTools.class);
            pctx.addImport(MVEL.class);
            pctx.addImport(StringTool.class);
            pctx.addImport(CompressionTools.class);
            parserContext = pctx;
        }
        return parserContext;
    }

    @TaskAction
    public void build() throws IOException, SQLException, ClassNotFoundException {
        Project project = getProject();
        File outputDir = new File(project.getBuildDir(), game);
        File sourceDir = new File(project.getProjectDir(), "addonSrc/" + game);
        FileUtils.deleteDirectory(outputDir);
        FileUtils.forceMkdir(outputDir);
        if (includeFrom != null) {
            for(String include : includeFrom) {
                processMVEL(include);
                processDir(new File(sourceDir.getParentFile(), include), outputDir);
            }
        }
        processMVEL(game);
        processDir(sourceDir, outputDir);
    }

    private void processMVEL(String mvelBaseName) throws IOException, SQLException, ClassNotFoundException {
        Project project = getProject();
        File mvelOutputDir = new File(project.getBuildDir(), mvelBaseName + "-mvel");
        FileUtils.deleteDirectory(mvelOutputDir);
        FileUtils.forceMkdir(mvelOutputDir);
        // process the mvel file

        File buildDir = project.getBuildDir();
        File dbDir = new File(buildDir, "db");
        if (!dbDir.exists()) {
            //noinspection ResultOfMethodCallIgnored
            dbDir.mkdirs();
        }
        File yamlFile = new File(project.getProjectDir(),"wowtools.yml");
        WowTools wowtools = new WowTools(yamlFile, dbDir);
        Map<String, Object> vars = new HashMap<>();
        vars.put("wowtools", wowtools);
        vars.put("outputDir", mvelOutputDir);
        vars.put("csv", new CSVTool(project.getProjectDir()));
        if (dbtool == null) {
            dbtool = new DBTool(project.getProjectDir(),"addon.db");
        }
        vars.put("db", dbtool);
        File mvelSourceDir = new File(
                project.getProjectDir(),
                "addonSrc/mvel"
        );
        vars.put("sourceDir", mvelSourceDir);
        vars.put("template", new TemplateTool(mvelSourceDir, mvelOutputDir));
        vars.put("blizzardSourceDir", new File(project.getProjectDir(),"addonSrc\\blizzard-sources"));
        File mvelSourceFile = new File(
                mvelSourceDir,
                mvelBaseName + ".mvel"
        );
        String script = FileUtils.readFileToString(mvelSourceFile, StandardCharsets.UTF_8);
        Serializable exp = MVEL.compileExpression(script, getParserContext());
        MVEL.executeExpression(exp, vars);
        //processDir(mvelOutputDir, new File(project.getBuildDir(),game), false);
    }

    private static void processDir(File srcDir, File outputDir) throws IOException {
        Stream<Path> walk = Files.walk(srcDir.toPath());
        Path srcDirAsPath = srcDir.toPath();
        for (Path srcPath : walk.toList()) {
            if (!srcPath.equals(srcDirAsPath)) {
                Path relativePath = srcDirAsPath.relativize(srcPath);
                Path outputPath = new File(outputDir, relativePath.toString()).toPath();
                if (srcPath.toFile().isDirectory()) {
                    //noinspection ResultOfMethodCallIgnored
                    outputPath.toFile().mkdir();
                } else {
                    Files.copy(srcPath, outputPath, StandardCopyOption.COPY_ATTRIBUTES);
                }
            }
        }
    }
}
