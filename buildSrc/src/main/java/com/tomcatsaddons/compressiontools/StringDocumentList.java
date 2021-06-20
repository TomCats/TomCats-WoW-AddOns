package com.tomcatsaddons.compressiontools;

import org.toubassi.femtozip.DocumentList;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

public class StringDocumentList implements DocumentList {
    final String[] documents;

    public StringDocumentList(String[] documents) {
        this.documents = documents;
    }

    @Override
    public int size() {
        return documents.length;
    }

    @Override
    public byte[] get(int i) throws IOException {
        return documents[i].getBytes(StandardCharsets.UTF_8);
    }
}
