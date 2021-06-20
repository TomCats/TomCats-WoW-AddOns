package com.tomcatsaddons.mvel;

import org.apache.commons.io.FileUtils;
import org.mvel2.templates.TemplateRuntime;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;

public class TemplateTool {

    File sourceDir;
    File outputDir;

    public TemplateTool(File sourceDir, File outputDir) {
        this.sourceDir = sourceDir;
        this.outputDir = outputDir;
    }

    public void mergeUTF8(String templateName, String outFilename, Map<String, Object> vars) throws IOException {
        mergeUTF8(new File(sourceDir, templateName), new File(outputDir, outFilename), vars);
    }

    public String mergeUTF8(String templateName, Map<String, Object> vars) throws IOException {
        return mergeUTF8(new File(sourceDir, templateName), vars);
    }

    public static void mergeUTF8(File templatePath, File outputPath, Map<String, Object> values) throws IOException {
        String output = mergeUTF8(templatePath, values);
        FileUtils.writeStringToFile(outputPath, output, StandardCharsets.UTF_8);
    }

    public static String mergeUTF8(File templatePath, Map<String, Object> values) throws IOException {
        String template = FileUtils.readFileToString(templatePath, StandardCharsets.UTF_8);
        return (String) TemplateRuntime.eval(template, values);
    }

    public void mergeCP1252(String templateFile, String outputFile, Map<String, Object> values) throws IOException {
        mergeCP1252(new File(sourceDir, templateFile), new File(outputDir, outputFile), values);
    }

    public static void mergeCP1252(File templatePath, File outputPath, Map<String, Object> values) throws IOException {
        String output = mergeCP1252(templatePath, values);
        FileUtils.writeStringToFile(outputPath, output, "CP1252");
    }

    public String mergeCP1252(String templateFile, Map<String, Object> values) throws IOException {
        return mergeCP1252(new File(sourceDir, templateFile), values);
    }

    public static String mergeCP1252(File templatePath, Map<String, Object> values) throws IOException {
        String template = FileUtils.readFileToString(templatePath, "CP1252");
        return (String) TemplateRuntime.eval(template, values);
    }


}
