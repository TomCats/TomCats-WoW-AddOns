package com.tomcatsaddons.wowtools;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class WowToolsTable {

    private final WowToolsDatabase database;
    private final String name;
    private final String localesDef;
    private final String columnTypes;

    private static String filenamePattern = "${table}-${build}-${locale}.csv";
    private String[] tokens = new String[] { "${table}", "${build}", "${locale}" };

    WowToolsTable(WowToolsDatabase database, String name, Map table) {
        this.database = database;
        this.name = name;
        this.localesDef = (String)table.get("locales");
        this.columnTypes = (String)table.get("columnTypes");
    }

    public URL getSourceURL(String locale) throws MalformedURLException {
        String[] params = new String[] { name, database.getBuild(), locale };
        String url = StringUtils.replaceEach(
                database.getConfiguration().getUrlPattern(),
                tokens,
                params
        );
        return new URL(url);
    }

    public File getCachedFile(String locale) {
        String[] params = new String[] { name, database.getBuild(), locale };
        String filename = StringUtils.replaceEach(
                filenamePattern,
                tokens,
                params
        );
        return new File(database.getConfiguration().getCacheDirectory(), filename);
    }

    public String[] getLocales() {
        if ("all".equals(localesDef)) {
            return database.getConfiguration().getLocales().clone();
        }
        return new String[] { database.getConfiguration().getDefaultLocale() };
    }

    public String getColumnTypes() {
        return columnTypes;
    }

    public WowToolsDatabase getDatabase() {
        return database;
    }

    public List<Map<String, Object>> query(String query, String locale) throws SQLException, ClassNotFoundException {
        return QueryTool.query(this, locale, query);
    }

}
