package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import com.ridgid.softwaresolution.closetmaid.data.Measures;
import com.ridgid.softwaresolution.closetmaid.data.Shelf;

public class CalculateCuts implements Comparator<Shelf>,Comparable<Shelf>{
	
	public CalculateCuts()
	{
		
	}
	
	public Measures[] GetResultTwo(ArrayList<Shelf> original,float shelfSize,boolean metric)
	{
		ArrayList<Shelf> input=new ArrayList<Shelf>(original.size());
		for(int i=0;i<original.size();i++)
		{
			Shelf c=original.get(i);
			Shelf copy=new Shelf(c.getQuantity(), c.getLength());
			input.add(copy);	
	    }
        Collections.sort(input, this);
        
        
        ArrayList<Measures> results=new ArrayList<Measures>();
        ArrayList<Float> currentCuts=new ArrayList<Float>();     
        boolean more=true;
        int i=0;
        while(more)
        {
        	Shelf current=input.get(i);	
        	//float total=0;
        	BigDecimal total=new BigDecimal(0);
        	currentCuts.clear();
        	boolean cutInProgress=true;
        	int j=i;
        	while(cutInProgress)
        	{    		
        			if(input.get(j).getQuantity()==0)
        			{
        				if(j<input.size()-1)
            			{
            				j++;
            			}
            			else
            			{
            				cutInProgress=false;
            				float[] measures=new float[currentCuts.size()];
            				for(int m=0;m<measures.length;m++)
            				{
            					measures[m]=currentCuts.get(m);
            				}
            				float waste=shelfSize-total.floatValue();
            				if(waste<0.01)
            				{
            					waste=0;
            				}
            				results.add(new Measures(measures,shelfSize, metric,waste));
            			}
        			}
        			else
        			{
        				boolean add=true;
        				if(metric)
        				{
        					float mod=((total.floatValue()+input.get(j).getLength()-15.24f)%(30.48f));
        					if(mod>=0f&&mod<2.53f)
        					{
        						if(total.floatValue()+2.54f+input.get(j).getLength()<=shelfSize)
        						{
        							//very probable it will be -1
        							total=total.add(new BigDecimal(2.54f));
        							currentCuts.add(0,-2.54f);
        						}
        						else
        						{
        							add=false;
        						}
        					}
        				}else
        				{
        					float mod=((total.floatValue()+input.get(j).getLength()-6f))%12f;
        					if(mod>=0f&&mod<0.99f)
        					{
        						if(total.floatValue()+1f+input.get(j).getLength()<=shelfSize)
        						{
        							//very probable it will be -1
        							total=total.add(new BigDecimal(1f));
        							currentCuts.add(0,-1f);
        						}
        						else
        						{
        							add=false;
        						}
        					}
        				}
        				if(total.floatValue()+input.get(j).getLength()<=shelfSize&&add)
                		{
        				//total+=input.get(j).getLength();
        				total=total.add(new BigDecimal(input.get(j).getLength()));
            			currentCuts.add(0,input.get(j).getLength());
            			input.get(j).setQuantity(input.get(j).getQuantity()-1);
                		}
                		else
                		{
                			if(j<input.size()-1)
                			{
                				j++;
                			}
                			else
                			{
                				cutInProgress=false;
                				float[] measures=new float[currentCuts.size()];
                				for(int m=0;m<measures.length;m++)
                				{
                					measures[m]=currentCuts.get(m);
                				}
                				float waste=shelfSize-total.floatValue();
                				if(waste<0.01)
                				{
                					waste=0;
                				}
                				results.add(new Measures(measures,shelfSize, metric,waste));
                			}
                		}
        			}
        			
        	}
        	if(current.getQuantity()==0)
        	{
        		boolean next=true;
        		while(next)
        		{
        			if(input.get(i).getQuantity()==0)
        			{
        			   i++;
        			   if(i==input.size())
        			   {
        				   next=false;
        				   more=false;
        			   }
        			}
        			else
        			{
        				next=false;
        			}
        		}
        	}
        }
		return results.toArray(new Measures[results.size()]);
	}
	
	
	public Measures[] GetResult(ArrayList<Shelf> original,float shelfSize,boolean metric)
	{
		ArrayList<Shelf> input=new ArrayList<Shelf>(original.size());
		for(int i=0;i<original.size();i++)
		{
			Shelf c=original.get(i);
			Shelf copy=new Shelf(c.getQuantity(), c.getLength());
			input.add(copy);	
	    }
        Collections.sort(input, this);
        
        ArrayList<Measures> results=new ArrayList<Measures>();
        ArrayList<Float> currentCuts=new ArrayList<Float>();     
        boolean more=true;
        int i=0;
        while(more)
        {
        	Shelf current=input.get(i);
        	BigDecimal total=new BigDecimal(0);
        	total=total.add(new BigDecimal(current.getLength()));
        	//float total=current.getLength();
        	current.setQuantity(current.getQuantity()-1);
        	currentCuts.clear();
        	currentCuts.add(current.getLength());
        	boolean cutInProgress=true;
        	int j=i;
        	while(cutInProgress)
        	{    		
        			if(input.get(j).getQuantity()==0)
        			{
        				if(j<input.size()-1)
            			{
            				j++;
            			}
            			else
            			{
            				cutInProgress=false;
            				float[] measures=new float[currentCuts.size()];
            				for(int m=0;m<measures.length;m++)
            				{
            					measures[m]=currentCuts.get(m);
            				}
            				float waste=shelfSize-total.floatValue();
            				if(waste<0.01)
            				{
            					waste=0;
            				}
            				results.add(new Measures(measures,shelfSize, metric,waste));
            			}
        			}
        			else
        			{
        				if(total.floatValue()+input.get(j).getLength()<=shelfSize)
                		{
        				//total+=input.get(j).getLength();
        				total=total.add(new BigDecimal(input.get(j).getLength()));
            			currentCuts.add(0,input.get(j).getLength());
            			input.get(j).setQuantity(input.get(j).getQuantity()-1);
                		}
                		else
                		{
                			if(j<input.size()-1)
                			{
                				j++;
                			}
                			else
                			{
                				cutInProgress=false;
                				float[] measures=new float[currentCuts.size()];
                				for(int m=0;m<measures.length;m++)
                				{
                					measures[m]=currentCuts.get(m);
                				}
                				float waste=shelfSize-total.floatValue();
                				if(waste<0.01)
                				{
                					waste=0;
                				}
                				results.add(new Measures(measures,shelfSize, metric,waste));
                			}
                		}
        			}
        			
        	}
        	if(current.getQuantity()==0)
        	{
        		boolean next=true;
        		while(next)
        		{
        			if(input.get(i).getQuantity()==0)
        			{
        			   i++;
        			   if(i==input.size())
        			   {
        				   next=false;
        				   more=false;
        			   }
        			}
        			else
        			{
        				next=false;
        			}
        		}
        	}
        }
		return results.toArray(new Measures[results.size()]);
	}

	@Override
	public int compare(Shelf lhs, Shelf rhs) {
		// TODO Auto-generated method stub
		if(lhs.getLength()>=rhs.getLength())
		{
			return -1;
		}
		else
		{
			return 1;
		}
	}

	@Override
	public int compareTo(Shelf another) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	


	
}
