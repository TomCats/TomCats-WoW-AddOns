package com.tomcatsaddons.wowtools;

import org.yaml.snakeyaml.Yaml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.util.*;

@SuppressWarnings("rawtypes")
public class WowTools {
    private final String urlPattern;
    private final String[] locales;
    private final String defaultLocale;
    private final File cacheDirectory;
    private final Map<String, WowToolsDatabase> databases;

    public WowTools(File yamlConfigurationFile, File cacheDirectory) throws FileNotFoundException {
        Yaml yaml = new Yaml();
        Map cfg = yaml.load(new FileInputStream(yamlConfigurationFile));
        this.defaultLocale = (String)cfg.get("default-locale");
        this.locales = ((String)cfg.get("locales")).split(",");
        this.urlPattern = (String)cfg.get("url-pattern");
        this.databases = new HashMap<>();
        this.cacheDirectory = cacheDirectory;
        Map databases = (Map)cfg.get("databases");
        //noinspection unchecked
        for (Map.Entry databaseEntry : (Set<Map.Entry>)databases.entrySet() ) {
            this.databases.put(
                    (String)databaseEntry.getKey(),
                    new WowToolsDatabase(this, (Map)databaseEntry.getValue())
            );
        }
    }

    public List<WowToolsTable> getTables() {
        List<WowToolsTable> allTables = new ArrayList<>();
        for (WowToolsDatabase database : databases.values()) {
            allTables.addAll(database.getTables());
        }
        return allTables;
    }

    // todo: Throw an exception if the database cannot be found
    public WowToolsDatabase getDatabase(String name) {
        return databases.get(name);
    }

    public WowToolsTable getTable(String dbName, String tablename) {
        return getDatabase(dbName).getTable(tablename);
    }

    String[] getLocales() {
        return locales;
    }

    public String getDefaultLocale() {
        return defaultLocale;
    }

    String getUrlPattern() {
        return urlPattern;
    }

    File getCacheDirectory() {
        return cacheDirectory;
    }

}
