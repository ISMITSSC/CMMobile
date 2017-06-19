package com.ridgid.softwaresolution.closetmaid.data;

import android.os.Parcel;
import android.os.Parcelable;

public class Shelf implements Parcelable {
	private int quantity;
	private float length;

	public Shelf(int quantity,float length)
	{
		this.quantity=quantity;
		this.length=length;
	}

	public int getQuantity()
	{
		return quantity;
	}

	public float getLength()
	{
		return length;
	}

	public void setLength(float lenght)
	{
		this.length=lenght;
	}
	public void setQuantity(int quantity)
	{
		this.quantity=quantity;
	}

	@Override
	public int describeContents() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		dest.writeInt(quantity);
		dest.writeFloat(length);
	}

	public static final Parcelable.Creator<Shelf> CREATOR
	= new Parcelable.Creator<Shelf>() {
		public Shelf createFromParcel(Parcel in) {
			return new Shelf(in);
		}

		public Shelf[] newArray(int size) {
			return new Shelf[size];
		}
	};

	private Shelf(Parcel in) {
		quantity = in.readInt();
		length = in.readFloat();
	}
	
}
