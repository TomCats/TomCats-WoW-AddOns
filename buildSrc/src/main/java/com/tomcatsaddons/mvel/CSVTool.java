package com.tomcatsaddons.mvel;

import com.tomcatsaddons.wowtools.WowToolsDatabase;
import com.tomcatsaddons.wowtools.WowToolsTable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class CSVTool {

    private final File projectDir;

    public CSVTool(File projectDir) {
        this.projectDir = projectDir;
    }

    public List<Map<String, Object>> query(String dbPath, String query, String columnTypes) throws ClassNotFoundException, SQLException {
        Class.forName("org.relique.jdbc.csv.CsvDriver");
        File dbPathFile = new File(projectDir, dbPath);
        @SuppressWarnings("StringBufferReplaceableByString")
        StringBuilder url = new StringBuilder()
                .append("jdbc:relique:csv:")
                .append(dbPathFile.getAbsolutePath())
                .append("?separator=,")
                .append("&fileExtension=.csv")
                .append("&charset=UTF-8");
        Properties props = new Properties();
        props.put("columnTypes",columnTypes);
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
