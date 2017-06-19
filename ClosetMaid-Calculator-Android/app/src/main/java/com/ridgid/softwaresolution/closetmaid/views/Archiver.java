package com.ridgid.softwaresolution.closetmaid.views;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class Archiver {
	
	private static Archiver instance = null;

	protected Archiver() {
	}

	private static Object sync = new Object();

	public static Archiver getInstance() {
		if (instance == null)
			synchronized (sync) {
				if (instance == null) {
					instance = new Archiver();
				}
			}
		return instance;
	}
	
	private void addToZip(ZipOutputStream zos,InputStream is,String filename) throws IOException, InterruptedException
	{
		byte[] bytes=new byte[8192];
		ZipEntry entry=new ZipEntry(filename);
		zos.putNextEntry(entry);
		int count;
		while((count=is.read(bytes))>0)
		{
			zos.write(bytes,0,count);
		}
		is.close();
		zos.closeEntry();
	}
	
	public void createArchive(ArrayList<File> files,File outputArchive)
	{
		try {
			if(outputArchive.exists()){
				outputArchive.delete();
			}
			FileOutputStream os = new FileOutputStream(outputArchive);
			ZipOutputStream zos = new ZipOutputStream(new BufferedOutputStream(os));
			try {
				for (int i = 0; i < files.size();i++) {
					InputStream is=new FileInputStream(files.get(i));
					addToZip(zos, is, files.get(i).getName());
				}
			} catch(Exception e){
				e.printStackTrace();
			}
			finally {
				zos.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
