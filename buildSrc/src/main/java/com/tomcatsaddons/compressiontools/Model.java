package com.tomcatsaddons.compressiontools;

import com.tomcatsaddons.lua.LuaTools;
import org.toubassi.femtozip.CompressionModel;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;

public class Model {

    public CompressionModel compressionModel;
    public byte[] dictionaryBytes;
    public String encoding;

    public String getDictionary() {
        return LuaTools.bytesAsCP1252String(dictionaryBytes);
    }

    private static void buildCodeword(int consumedBitLength, int[] codeword, Object[] tables, int[][] codewords) {
        int activeBitLength = codeword[1] - consumedBitLength;
        if (activeBitLength <= 8) {
            int jcount = 1 << (8 - activeBitLength);
            for (int j = 0; j < jcount; j++) {
                int index = (j << activeBitLength) | (codeword[0] >> consumedBitLength);
                codewords[index] = codeword;
            }
        } else {
            int index = (codeword[0] >> consumedBitLength) & 0xff;
            Object[] subtable = (Object[])tables[index];
            if (subtable == null) {

                subtable = new Object[] { new int[256][], new Object[256] };
                tables[index] = subtable;
            }
            buildCodeword(consumedBitLength + 8, codeword, (Object[])subtable[1], (int[][])subtable[0]);
        }
    }

    public static Object[] build(byte[] data) throws IOException {
        DataInputStream in = new DataInputStream(new ByteArrayInputStream(data));
        in.readInt(); // dispose version number
        int dictionaryLength = in.readInt();
        Object[] model = new Object[3];
//        Object[] model = new Object[6];
        byte[] dictionary = new byte[dictionaryLength];
        model[0] = dictionary;
        int totalRead = 0;
        int numRead;
        while ((numRead = ((InputStream) in).read(dictionary, totalRead, dictionaryLength - totalRead)) > -1 && totalRead < dictionaryLength) {
            totalRead += numRead;
        }
        model[1] = new int[5][][];
        model[2] = new Object[5];
        Object[] decoding = (Object[])model[2];
        for (int i = 0; i < 5; i++) {
            int[][] encoding = new int[in.readInt()][];
            //if (i == 0) {
            //model[1] = encoding;
            ((int[][][]) model[1])[i] = encoding;
            //}
            for (int i1 = 0, count = encoding.length; i1 < count; i1++) {
                if (in.readBoolean()) {
                    encoding[i1] = new int[3];
                    encoding[i1][0] = in.readInt();
                    encoding[i1][1] = in.readInt();
                    encoding[i1][2] = in.readInt();
                }
            }
        }
        int[][][] encoding = (int[][][])model[1];
        for (int i = 0; i < 5; i++) {
            Object[] decodeTable = new Object[] { new int[256][], new Object[256] };
            for (int[] codeword : encoding[i]) {
                buildCodeword(0, codeword, (Object[]) decodeTable[1], (int[][]) decodeTable[0]);
            }
            decoding[i] = decodeTable;
        }
        return model;
    }

}
