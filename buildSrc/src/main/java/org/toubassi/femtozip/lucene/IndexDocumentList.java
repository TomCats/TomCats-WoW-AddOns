/**
 *   Copyright 2011 Garrick Toubassi
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package org.toubassi.femtozip.lucene;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexReader;
import org.toubassi.femtozip.DocumentList;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * This is a bit whack
 */
public class IndexDocumentList implements DocumentList {
    
    private IndexReader reader;
    private String fieldName;
    private int numDocs;
    private int[] docIds;
    private int[] fieldCounts;
    
    public IndexDocumentList(IndexReader reader, int numSamples, int firstDoc, String fieldName) throws IOException {
        this.reader = reader;
        this.fieldName = fieldName;
        numDocs = reader.numDocs();
        float samplingRate = ((float)numSamples) / numDocs;

        ArrayList<Integer> docIdsList = new ArrayList<Integer>();
        ArrayList<Integer> fieldCountList = new ArrayList<Integer>();
        
        int numDocsScanned = 0, numDocsSampled = 0;
        for (int i = firstDoc, count = reader.maxDoc(); i < count; i++) {
            numDocsScanned++;
            
            if (reader.isDeleted(i)) {
                continue;
            }
            
            if (((int)(numDocsScanned * samplingRate)) <= numDocsSampled) {
                continue;
            }
            
            numDocsSampled++;
            
            Document doc = reader.document(i);
            Field fields[] = doc.getFields(fieldName);
            if (fields.length > 0) {
                if (fields[0].isStored()) {
                    docIdsList.add(i);
                    fieldCountList.add(fields.length);
                }
            }
        }
        
        docIds = new int[docIdsList.size()];
        for (int i = 0, count = docIdsList.size(); i < count; i++) {
            docIds[i] = docIdsList.get(i);
        }
        
        fieldCounts = new int[fieldCountList.size()];
        for (int i = 0, count = fieldCountList.size(); i < count; i++) {
            fieldCounts[i] = fieldCountList.get(i);
            if (i > 0) {
                fieldCounts[i] += fieldCounts[i - 1];
            }
        }
    }

    public int size() {
        return fieldCounts.length == 0 ? 0 : fieldCounts[fieldCounts.length - 1];
    }
    
    public byte[] get(int i) throws IOException {
        i++;
        int index = Arrays.binarySearch(fieldCounts, i);
        int docId;
        int fieldIndex = 0;
        if (index >= 0) {
            docId = docIds[index]; 
        }
        else {
            index = -index - 1;
            docId = docIds[index];
            fieldIndex = i - 1;
            if (index > 0) {
                fieldIndex -= fieldCounts[index - 1];
            }
        }
        Document doc = reader.document(docId);
        Field fields[] = doc.getFields(fieldName);
        Field field = fields[fieldIndex];

        byte[] bytes;
        
        if (field.isBinary()) {
            bytes = new byte[field.getBinaryLength()];
            System.arraycopy(field.getBinaryValue(), field.getBinaryOffset(), bytes, 0, field.getBinaryLength());
        }
        else {
            String value = field.stringValue();
            bytes = value.getBytes("UTF-8");
        }
        
        return bytes;
    }
}
