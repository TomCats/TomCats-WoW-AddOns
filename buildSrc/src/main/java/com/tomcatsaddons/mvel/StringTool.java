package com.tomcatsaddons.mvel;

public class StringTool {

    public static String augment(String source, String augmentSpec) {
        String[] steps = augmentSpec.split("\\|\\|");
        StringBuilder sb = new StringBuilder();
        for (String step : steps) {
            if (step.startsWith("lines:")) {
                String[] lines = source.split("\\r?\\n");
                int start = 0;
                int end = 0;
                if (step.endsWith("+")) {
                    start = Integer.parseInt(step.substring(6,step.length() - 1)) - 1;
                    end = lines.length;
                } else if (step.contains("-")) {
                    //todo: implement
                } else {
                    //todo: implement
                }
                for (int i = start; i < end; i++) {
                    sb.append(lines[i]).append("\r\n");
                }
            }

        }
        return sb.toString();
    }
}
