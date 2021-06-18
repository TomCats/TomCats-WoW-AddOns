package com.tomcatsaddons.wowtools;

import java.util.*;

@SuppressWarnings({"rawtypes", "unchecked"})
public class WowToolsDatabase {

    private final WowTools configuration;
    private final Map<String, WowToolsTable> tables;
    private final String build;

    WowToolsDatabase(WowTools configuration, Map database) {
        this.configuration = configuration;
        this.build = (String)database.get("build");
        this.tables = new HashMap<>();
        Map tables = (Map)database.get("tables");
        for (Map.Entry tablesEntry : (Set<Map.Entry>)tables.entrySet() ) {
            String key = (String)tablesEntry.getKey();
            this.tables.put(
                    key,
                    new WowToolsTable(this, key, (Map)tablesEntry.getValue())
            );
        }
    }

    public WowToolsTable getTable(String name) {
        return tables.get(name);
    }

    Collection<WowToolsTable> getTables() {
        return tables.values();
    }

    String getBuild() {
        return build;
    }

    WowTools getConfiguration() {
        return configuration;
    }

}
