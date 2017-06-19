package com.ridgid.softwaresolution.closetmaid.data;

import android.os.Parcel;
import android.os.Parcelable;

public class HardwareShelf implements Parcelable{

		int quantity;
		int locationType;
		float length;
		
		
		
		public int getQuantity() {
			return quantity;
		}


		public void setQuantity(int quantity) {
			this.quantity = quantity;
		}


		public int getLocationType() {
			return locationType;
		}


		public void setLocationType(int locationType) {
			this.locationType = locationType;
		}


		public float getLength() {
			return length;
		}


		public void setLength(float length) {
			this.length = length;
		}
		
		public HardwareShelf(int quantity,int locationType,float length){
			this.quantity=quantity;
			this.locationType=locationType;
			this.length=length;
		}
		
		
		@Override
		public int describeContents() {
			// TODO Auto-generated method stub
			return 0;
		}
		@Override
		public void writeToParcel(Parcel dest, int flags) {
			dest.writeInt(quantity);
			dest.writeInt(locationType);
			dest.writeFloat(length);
		}
		
		public static final Parcelable.Creator<HardwareShelf> CREATOR
		= new Parcelable.Creator<HardwareShelf>() {
			public HardwareShelf createFromParcel(Parcel in) {
				return new HardwareShelf(in);
			}

			public HardwareShelf[] newArray(int size) {
				return new HardwareShelf[size];
			}
		};

		private HardwareShelf(Parcel in) {
			quantity = in.readInt();
			locationType=in.readInt();
			length = in.readFloat();
		}
}
