package com.tomcatsaddons.mvel;

import com.tomcatsaddons.wowtools.WowToolsTable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;
import org.sqlite.SQLiteConfig;

import java.io.File;
import java.sql.*;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class DBTool {

    private final File projectDir;
    private final Connection connection;

    public DBTool(File projectDir, String dbname) throws ClassNotFoundException, SQLException {
        this.projectDir = projectDir;
        Class.forName("org.sqlite.JDBC");
        SQLiteConfig config = new SQLiteConfig();
        config.setEncoding(SQLiteConfig.Encoding.UTF_16BE);
        connection = DriverManager.getConnection("jdbc:sqlite::memory:", config.toProperties());
        connection.setAutoCommit(false);
    }

    public void loadCSV(String csvFile, String columnTypes) throws SQLException, ClassNotFoundException {
        File dbPathFile = new File(projectDir, csvFile);
        ConnectionInfo connectionInfo = new ConnectionInfo();
        //noinspection StringBufferReplaceableByString
        connectionInfo.url = new StringBuilder()
                .append("jdbc:relique:csv:")
                .append(dbPathFile.getParentFile().getAbsolutePath())
                .append("?separator=,")
                .append("&fileExtension=.csv")
                .append("&charset=UTF-8")
                .toString();
        connectionInfo.tableName = dbPathFile.getName().replaceAll("(?<!^)[.].*", "");
        connectionInfo.columnTypes = columnTypes;
        loadCSV(connectionInfo);
    }

    public void loadCSV(WowToolsTable table) throws SQLException, ClassNotFoundException {
        ConnectionInfo connectionInfo = new ConnectionInfo();
        //noinspection StringBufferReplaceableByString
        for (String locale : table.getLocales()) {
            connectionInfo.url = new StringBuilder()
                    .append("jdbc:relique:csv:")
                    .append(table.getDatabase().getConfiguration().getCacheDirectory().toString())
                    .append("?separator=,")
                    .append("&fileExtension=-")
                    .append(table.getDatabase().getBuild())
                    .append("-")
                    .append(locale)
                    .append(".csv")
                    .append("&charset=UTF-8")
                    .toString();
            connectionInfo.tableName = table.getName();
            if (table.getLocales().length > 1)
                connectionInfo.locale = locale;
            connectionInfo.columnTypes = table.getColumnTypes();
            loadCSV(connectionInfo);
        }
    }

    private static String escapeColumnName(String columnName) {
        return columnName.replace("[","").replace("]","");
    }

    public void loadCSV(ConnectionInfo connectionInfo) throws SQLException, ClassNotFoundException {
        Properties props = new Properties();
        props.put("columnTypes",connectionInfo.columnTypes);
        Connection csvConnection = DriverManager.getConnection(connectionInfo.url, props);
        Statement statement = csvConnection.createStatement();
        ResultSet rs = statement.executeQuery("select * from " + connectionInfo.tableName);
        ResultSetMetaData resultSetMetaData = rs.getMetaData();
        int columnCount = resultSetMetaData.getColumnCount();
        String tableName = connectionInfo.tableName;
        if (connectionInfo.locale != null) {
            tableName = tableName + "_" + connectionInfo.locale;
        }
        StringBuilder createQuery = new StringBuilder("CREATE TABLE ")
                .append(tableName)
                .append(" (");
        for(int i = 1; i<columnCount; i++ ) {
            createQuery.append(escapeColumnName(resultSetMetaData.getColumnName(i)))
                    .append(" ")
                    .append(resultSetMetaData.getColumnTypeName(i))
                    .append("(")
                    .append(resultSetMetaData.getPrecision(i))
                    .append("), ");
        }
        createQuery.append(escapeColumnName(resultSetMetaData.getColumnName(columnCount)))
                .append(" ")
                .append(resultSetMetaData.getColumnTypeName(columnCount))
                .append("(")
                .append(resultSetMetaData.getPrecision(columnCount))
                .append(") ) ");
        Statement sqliteStatement = connection.createStatement();
        sqliteStatement.execute(createQuery.toString());
        StringBuilder insertStatementSB = new StringBuilder()
                .append("INSERT INTO ")
                .append(tableName)
                .append(" VALUES(");
        for(int i = 0; i<columnCount; i++ ) {
            insertStatementSB.append("?,");
        }
        insertStatementSB.deleteCharAt(insertStatementSB.length() - 1);
        insertStatementSB.append(");");
        PreparedStatement insertRecord = connection.prepareStatement(
                insertStatementSB.toString()
        );
        while(rs.next()) {
            for(int i = 0; i<columnCount; i++ ) {
                insertRecord.setObject(i+1, rs.getObject(i+1), resultSetMetaData.getColumnType(i+1));
            }
            insertRecord.execute();
        }
        connection.commit();
    }

    static class ConnectionInfo {
        String url;
        String tableName;
        String columnTypes;
        String locale;
    }

    public List<Map<String, Object>> query(String query) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(
                new SingleConnectionDataSource(
                        connection, true
                )
        );
        List<Map<String, Object>> result = jdbcTemplate.queryForList(query);
        return result;
    }

    public List<String> queryForStringList(String query) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(
                new SingleConnectionDataSource(
                        connection, true
                )
        );
        return jdbcTemplate.queryForList(query, String.class);
    }

}

