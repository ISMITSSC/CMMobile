package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools;

import java.util.ArrayList;

import com.ridgid.softwaresolution.closetmaid.data.Shelf;

public class ShelfList extends ArrayList<Shelf>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	Shelf max;
	
	
	public Shelf getMax() {
		return max;
	}


	@Override
	public void add(int index, Shelf object) {
		// TODO Auto-generated method stub
		super.add(index, object);
		if(max==null)
		{
			max=object;
		}
		else
		{
			if(object.getLength()>max.getLength())
			{
				max=object;
			}
		}
	}
}
