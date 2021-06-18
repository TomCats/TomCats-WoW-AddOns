package com.tomcatsaddons.wowtools;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;

import java.sql.*;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class QueryTool {

    public static List<Map<String, Object>> query(WowToolsTable table, String locale, String query) throws ClassNotFoundException, SQLException {
        WowToolsDatabase database = table.getDatabase();
        Class.forName("org.relique.jdbc.csv.CsvDriver");
        @SuppressWarnings("StringBufferReplaceableByString")
        StringBuilder url = new StringBuilder()
                .append("jdbc:relique:csv:")
                .append(database.getConfiguration().getCacheDirectory().toString())
                .append("?separator=,")
                .append("&fileExtension=-")
                .append(database.getBuild())
                .append("-")
                .append(locale)
                .append(".csv")
                .append("&charset=UTF-8");
        Properties props = new Properties();
        props.put("columnTypes",table.getColumnTypes());
        Connection conn = DriverManager.getConnection(url.toString(), props);
        JdbcTemplate jdbcTemplate = new JdbcTemplate(
                new SingleConnectionDataSource(
                        conn, false
                )
        );
        List<Map<String, Object>> result = jdbcTemplate.queryForList(query);
        conn.close();
        return result;
    }

}
