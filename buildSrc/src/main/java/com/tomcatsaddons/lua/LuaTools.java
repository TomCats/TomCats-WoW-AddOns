package com.tomcatsaddons.lua;

import org.luaj.vm2.*;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@SuppressWarnings("unused")
public class LuaTools {

    // work-around for HSQL Arrays now being plain strings
    public static String asInnerString(String arrayString) {
        if (arrayString == null) {
            return "";
        }
        if (arrayString.startsWith("[")) arrayString = arrayString.substring(1);
        if (arrayString.endsWith("]")) arrayString = arrayString.substring(0, arrayString.length() - 1);
        arrayString = arrayString.replace("[","{");
        arrayString = arrayString.replace("]","}");
        return arrayString;
    }

    public static String asInnerString(Object[] obj) {
        if (obj == null) {
            return "";
        }
        return asString(obj, true);
    }

    private static int fullEscape(byte[] buff, int bufflen, byte aByte) {
        int asInt = aByte & 0xFF;
        String num;
        if (asInt < 10) {
            num = "\\00" + asInt;
        } else if (asInt < 100) {
            num = "\\0" + asInt;
        } else {
            num = "\\" + asInt;
        }
        byte[] oBytes = num.getBytes();
        for (byte oByte : oBytes) {
            buff[bufflen++] = oByte;
        }
        return bufflen;
    }

    public static String bytesAsCP1252String(byte[] bytes) {
        Charset CP1252 = Charset.forName("CP1252");
        byte[] buff = new byte[bytes.length * 4];
        int bufflen = 0;
        for (byte aByte : bytes) {
            switch (aByte) {
                case (34):
                case (92):
                    buff[bufflen++] = 92;
                    buff[bufflen++] = aByte;
                    break;
                case (10):
                    buff[bufflen++] = 92;
                    buff[bufflen++] = 'n';
                    break;
                case (13):
                    buff[bufflen++] = 92;
                    buff[bufflen++] = 'r';
                    break;
                case (-127):
                case (-115):
                case (-113):
                case (-112):
                case (-99):
                case (0):
                    bufflen = fullEscape(buff, bufflen, aByte);
                    break;
                default: {
                    buff[bufflen++] = aByte;
                }
            }
        }
        return new String(buff,0,bufflen, CP1252);
    }

    public static String bytesAsUTF8String(byte[] bytes) {
        Charset UTF8 = StandardCharsets.UTF_8;
        byte[] buff = new byte[bytes.length * 4];
        int bufflen = 0;
        for (int i = 0, bytesLength = bytes.length; i < bytesLength; i++) {
            byte aByte = bytes[i];
            switch (aByte) {
                case (34):
                case (92):
                    buff[bufflen++] = 92;
                    buff[bufflen++] = aByte;
                    break;
                case (10):
                    buff[bufflen++] = 92;
                    buff[bufflen++] = 'n';
                    break;
                case (13):
                    buff[bufflen++] = 92;
                    buff[bufflen++] = 'r';
                    break;
                case (0):
                    bufflen = fullEscape(buff, bufflen, aByte);
                    break;
                default: {
                    if (aByte > 0) {
                        buff[bufflen++] = aByte;
                    } else {
                        if (i + 1 < bytes.length) {
                            byte[] b1 = new byte[]{aByte, bytes[i + 1]};
                            byte[] b2 = new String(b1, UTF8).getBytes(UTF8);
                            if (b1[0] == b2[0] && b1[1] == b2[1]) {
                                buff[bufflen++] = aByte;
                                buff[bufflen++] = bytes[i+1];
                                i++;
                                break;
                            }
                            if (i + 2 < bytes.length) {
                                b1 = new byte[]{aByte, bytes[i + 1], bytes[i + 2]};
                                b2 = new String(b1, UTF8).getBytes(UTF8);
                                if (b1[0] == b2[0] && b1[1] == b2[1] && b1[2] == b2[2]) {
                                    buff[bufflen++] = aByte;
                                    buff[bufflen++] = bytes[i + 1];
                                    buff[bufflen++] = bytes[i + 2];
                                    i+=2;
                                    break;
                                }
                            }
                            if (i + 3 < bytes.length) {
                                b1 = new byte[]{aByte, bytes[i + 1], bytes[i + 2], bytes[i + 3]};
                                b2 = new String(b1, UTF8).getBytes(UTF8);
                                if (b1[0] == b2[0] && b1[1] == b2[1] && b1[2] == b2[2] && b1[3] == b2[3]) {
                                    buff[bufflen++] = aByte;
                                    buff[bufflen++] = bytes[i + 1];
                                    buff[bufflen++] = bytes[i + 2];
                                    buff[bufflen++] = bytes[i + 3];
                                    i+=3;
                                    break;
                                }
                            }
                        }
                        bufflen = fullEscape(buff, bufflen, aByte);
                    }
                }
            }
        }
        return new String(buff,0,bufflen, UTF8);
    }

    public static String asString(Object obj, boolean stripOuterBraces) {
        StringBuilder sb = new StringBuilder();
        if (obj instanceof Object[]) {
            if (!stripOuterBraces) sb.append("{");
            for (Object o : (Object[]) obj) {
                sb.append(asString(o,false));
                sb.append(",");
            }
            sb.deleteCharAt(sb.length() - 1);
            if (!stripOuterBraces) sb.append("}");
        } else if (obj instanceof Number) {
            sb.append(obj.toString());
        } else if (obj instanceof List) {
            if (!stripOuterBraces) sb.append("{");
            //noinspection rawtypes
            for (Object o : (List)obj) {
                if (o != null) {
                    sb.append(asString(o, false));
                } else {
                    sb.append("_");
                }
                sb.append(",");
            }
            sb.deleteCharAt(sb.length() - 1);
            if (!stripOuterBraces) sb.append("}");
        } else {
            sb.append("\"")
                    .append(obj.toString()
                            .replace("\\","\\\\")
                            .replaceAll("\"","\\\\\""))
                    .append("\"");
        }
        return sb.toString();
    }

    private static LuaTable getLuaTable(Object[] objs) {
        LuaTable luaTable = new LuaTable(objs.length,0);
        int idx = 1;
        for (Object obj : objs) {
            luaTable.insert(idx++,getLuaValue(obj));
        }
        return luaTable;
    }

    private static LuaValue getLuaValue(Object obj) {
        if (obj instanceof Object[]) {
            return getLuaTable((Object[]) obj);
        }
        if (obj instanceof Number) {
            return LuaInteger.valueOf((Integer)obj);
        }
        return LuaString.valueOf(obj.toString());
    }

    public static String createContiguousArrayString(List<Object> results, boolean trimWhitespace) {
        StringBuilder luaRaw = new StringBuilder("return {");
        for (Object result : results) {
            if (result instanceof String) {
                String name = result.toString();
                if (trimWhitespace) {
                    name = name.trim();
                }
                if (name == null || name.length() == 0) {
                    luaRaw.append("_,");
                } else {
                    String name1 = name.replaceAll("\"", "\\\\\"")
                            .replaceAll("\r", "\\\\\r")
                            .replaceAll("\n", "\\\\\n");
                    luaRaw.append("\"").append(name1).append("\",");
                }
            } else {
                luaRaw.append(result).append(",");
            }
        }
        if (luaRaw.length() > 8)
            luaRaw.deleteCharAt(luaRaw.length() - 1);
        luaRaw.append("}");
        return luaRaw.toString();
    }

    public static String createContiguousArrayString(List<Map<String, Object>> results, String indexField) {
        int nextID = 1;
        StringBuilder luaRaw = new StringBuilder("local _ = nil return {");
        for(Map<String, Object> result : results) {
            int id = (Integer)result.get(indexField);
            while (nextID != id) {
                luaRaw.append("_,");
                nextID++;
            }
            nextID++;
            String name = (String)result.get("VAL");
            if (name == null || name.length() == 0) {
                luaRaw.append("_,");
            } else {
                String name1 = name.replaceAll("\"","\\\\\"")
                        .replaceAll("\r","\\\\\r")
                        .replaceAll("\n","\\\\\n");
                luaRaw.append("\"").append(name1).append("\",");
            }
        }
        luaRaw.deleteCharAt(luaRaw.length() - 1);
        luaRaw.append("}");
        return luaRaw.toString();
    }

    public static String createContiguousArrayString(ResultSet results) throws SQLException {
        int nextID = 1;
        StringBuilder luaRaw = new StringBuilder("local _ = nil return {");
        while(results.next()) {
            int column = 1;
            int id = results.getInt(1);
            while (nextID != id) {
                luaRaw.append("_,");
                nextID++;
            }
            nextID++;
            String name = results.getString(2);
            if (name.length() == 0) {
                luaRaw.append("_,");
            } else {
                String name1 = name
                        .replaceAll("\"","\\\\\"")
                        .replaceAll("\r","\\\\\r")
                        .replaceAll("\n","\\\\\n");
                luaRaw.append("\"").append(name1).append("\",");
            }
        }
        luaRaw.deleteCharAt(luaRaw.length() - 1);
        luaRaw.append("}");
        return luaRaw.toString();
    }
}
