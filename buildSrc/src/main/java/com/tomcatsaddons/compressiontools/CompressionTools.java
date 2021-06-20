package com.tomcatsaddons.compressiontools;

import com.tomcatsaddons.lua.LuaTools;
import org.toubassi.femtozip.CompressionModel;
import org.toubassi.femtozip.models.FemtoZipCompressionModel;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;

public class CompressionTools {

    public static Model buildModel(String[] documents) throws IOException {
        FemtoZipCompressionModel compressionModel = (FemtoZipCompressionModel)CompressionModel.buildOptimalModel(new StringDocumentList(documents), null, new CompressionModel[] { new FemtoZipCompressionModel()} , true);
        ByteArrayOutputStream bytesOut = new ByteArrayOutputStream();
        DataOutputStream dataOut = new DataOutputStream(bytesOut);
        compressionModel.save(dataOut);
        Object[] modelBytes = Model.build(bytesOut.toByteArray());
        Model model = new Model();
        model.compressionModel = compressionModel;
        model.dictionaryBytes = compressionModel.getDictionary();
        model.encoding = "return " + objectAsLuaString(modelBytes[1]);
        return model;
    }

    public static String compress(Model model, byte[] data) {
        byte[] compressed = model.compressionModel.compress(data);
        return LuaTools.bytesAsCP1252String(compressed);
    }

    public static String objectAsLuaString(Object o) {
        StringBuilder sb = new StringBuilder();
        if (o == null) {
            sb.append("_");
        } else if (o instanceof int[]) {
            sb.append("{");
            for (int o1 : (int[]) o) {
                sb.append(o1).append(",");
            }
            if (sb.length() > 1) {
                sb.deleteCharAt(sb.length() - 1);
            }
            sb.append("}");
        } else if (o instanceof byte[]) {
            sb.append("\"");
            String s = new String((byte[])o).replaceAll("\"","\\\\\"");
            sb.append(s);
            sb.append("\"");
        } else if (o instanceof Object[]) {
            sb.append("{");
            for (Object o1 : (Object[]) o) {
                sb.append(objectAsLuaString(o1)).append(",");
            }
            if (sb.length() > 1) {
                sb.deleteCharAt(sb.length() - 1);
            }
            sb.append("}");
        }
        return sb.toString();
    }

}
