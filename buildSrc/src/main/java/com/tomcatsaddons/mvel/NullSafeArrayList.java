package com.tomcatsaddons.mvel;

import java.util.ArrayList;
import java.util.Collection;

public class NullSafeArrayList<E> extends ArrayList<E> {

    public NullSafeArrayList(Collection<E> c) {
        super(c);
    }

    public E get(int index) {
        if (this.size() < index - 1) {
            return null;
        }
        return super.get(index);
    }

}
