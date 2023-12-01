package com.intra.util.excel;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletOutputStream;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.push.controller.Users_controller;
import com.push.service.Users_service;

import lombok.*;
import java.util.*;

public class CExcelDocBuild   {
	/**
	 * 
	 */
	@Getter
	@Setter
	private String excelFileName;
	/**
	 * 
	 */
	@Getter
	@Setter
	String labels[];
	@Getter
	@Setter
	int columnWidth[];
	@Getter
	@Setter
	String sheetName;

	@Getter
	@Setter
	int rowIndex;
	@Getter
	@Setter
	ServletOutputStream out;

	private 
	SXSSFSheet   sheet;
	
	private static final Logger logger = LoggerFactory
			.getLogger(CExcelDocBuild.class.getSimpleName());
	@Getter
	SXSSFWorkbook workbook ; // 1024 * 1024 mean
													// buffer size
	CExcelDocBuild() {
		excelFileName = null;
		labels = null;
		sheetName = null;
		rowIndex = 1;
		workbook = new SXSSFWorkbook(256 * 1024);
		workbook.setCompressTempFiles(true);
	}
	public
	CExcelDocBuild(String labels[],int columnWidth[],  String sheetNames) 
	{
		//long time = System.currentTimeMillis();
		//SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		//String str = dayTime.format(new Date(time));
		this.excelFileName = "Default.xls";
		this.labels = labels;
		this.sheetName = sheetNames;
		this.columnWidth = columnWidth;
		rowIndex = 1;
		workbook = new SXSSFWorkbook(256 * 1024);
		workbook.setCompressTempFiles(true);
	}
	public
	CExcelDocBuild(String excelFileName, String labels[], int columnWidth[] , String sheetNames) {
		this();
		this.excelFileName = excelFileName;
		this.labels = labels;
		this.sheetName = sheetNames;
		//workbook.setCompressTempFiles(true);
	}
	public void createNewSheet(int sheetNum , String sheetName){
		this.sheetName = sheetName;
		createNewSheet(sheetNum);
	}
	
	 
	public void createNewSheet(int sheetNum)
	{
	    this.sheet = workbook.createSheet();
 
		workbook.setSheetName( sheetNum , this.sheetName);	
		try {
			createColumnLabel(this.sheet);
		} catch (Exception e) {
			  
			//	e.printStackTrace();
			if(logger.isDebugEnabled())
			{
				logger.debug(e.getLocalizedMessage());
			} 
		}
	}
	public void addRowList(  List<Map<String, Object>> __list ) {
		try {
			int cellIndex = 0;
			 
			for (Map<String, Object> _list : __list) {
				SXSSFRow row = sheet.createRow(rowIndex++);
				cellIndex = 0;
				for(Object value : _list.values())
				{
					SXSSFCell cell = row.createCell(cellIndex++);
					//System.out.println("\n"+String.valueOf(value) );
					if (value instanceof String)
						cell.setCellValue((String)value);
					else if (value instanceof java.sql.Timestamp) {
						SimpleDateFormat sdf = new SimpleDateFormat();
						// sdf.setTimeZone(new
						// SimpleTimeZone(0,"GMT"));
						sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
						sdf.applyPattern(
								"yyyy-MMM-dd HH:mm:ss z");
						cell.setCellValue(sdf.format(
								((java.sql.Timestamp) value)));
					} else
						cell.setCellValue(String.valueOf(value));
					
					//logger.debug(String.valueOf(value));
					//cell = null;
				}
				//row = null;
			}
		} catch (Exception e) {
			logger.info("Excel Error {}" , e.getLocalizedMessage());
			try {
				sheet.flushRows();
				if(logger.isDebugEnabled())
				{
					logger.debug(e.getLocalizedMessage());
				}
			} catch (IOException e1) {
				if(logger.isDebugEnabled())
				{
					logger.debug(e1.getLocalizedMessage());
				}
			}
		} finally {
		}
	}
	 
	public void addRowList(SXSSFSheet sheet , List<HashMap<String, String>> rowlist ) {
		try {
			int cellIndex = 0;
			for (HashMap<String, String> _list : rowlist) {
				SXSSFRow row = sheet.createRow(rowIndex++);
				cellIndex = 0;
				for(String value : _list.values())
				{
					SXSSFCell cell = row.createCell(cellIndex++);
					cell.setCellValue(value);
				//	cell = null;
				}
			//	row = null;
			}
		} catch (Exception e) {
		//	e.printStackTrace();
			try {
				sheet.flushRows();
				if(logger.isDebugEnabled())
				{
					logger.debug(e.getLocalizedMessage());
				}
			} catch (IOException e1) {
				if(logger.isDebugEnabled())
				{
					logger.debug(e1.getLocalizedMessage());
				}
			}
		} finally {
		}
	}
	/**
	 * 
	 * @Method Name : createColumnLabel
	 * @작성일 : 2022. 9. 5.
	 * @작성자 : Foryoucom
	 * @변경이력 :
	 * @Method 설명 :
	 * @param sheet
	 * @param columnWidth
	 * @throws Exception
	 */
	// 행제한
	// Excel 97~2003 형식(*,xls) : 65,536행/256열 1
	// Excel 2007~2013 (*.xlsx/xlsm) : 1,048,576행x16,384열 2
	private void createColumnLabel(SXSSFSheet sheet)
			  {
		// 속성
		CellStyle cellStyle = (CellStyle) workbook.createCellStyle();
		Font font = workbook.createFont();
 
		try {
	//	font.setFontName("ARIAL");
			font.setFontName("맑은 고딕");
		font.setBold(true);
		font.setFontHeightInPoints((short) 12);
		font.setColor(IndexedColors.WHITE.getIndex());

		cellStyle.setFont(font);
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setFillForegroundColor((short) 0x2080D0);
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		cellStyle.setBorderTop(BorderStyle.THIN);
		cellStyle.setTopBorderColor(IndexedColors.WHITE.getIndex());
		cellStyle.setBorderLeft(BorderStyle.THIN);
		cellStyle.setLeftBorderColor(IndexedColors.WHITE.getIndex());
		cellStyle.setBorderRight(BorderStyle.THIN);
		cellStyle.setRightBorderColor(IndexedColors.WHITE.getIndex());
		cellStyle.setBorderBottom(BorderStyle.THIN);
		cellStyle.setBottomBorderColor(IndexedColors.WHITE.getIndex());

		// 라벨
		SXSSFRow firstRow = sheet.createRow(0);
		for (int i = 0; i < labels.length; i++) {
			SXSSFCell cell = firstRow.createCell(i);
			cell.setCellValue(labels[i]);
			cell.setCellStyle(cellStyle);
			//cell = null;
		}
		if (columnWidth.length > 0 ) {
			final short width = 256;
			for (int i = 0; i < columnWidth.length; i++)
			sheet.setColumnWidth(i, (columnWidth[i] * width));
		}else
		{
			sheet.setDefaultColumnWidth(256);
		}
		//firstRow = null;
		}catch(Exception e)
		{
			logger.debug(e.getLocalizedMessage());
		}
		 
	}

	 
	public void close() throws Exception {
		excelFileName = null;
		labels = null;
		sheetName = null;
		columnWidth = null;
	
		logger.debug("CALL CLOSE");
		try {
		 	workbook.dispose();
			workbook.close();
		} catch (IOException e) {
			if (logger.isDebugEnabled()) {
				logger.error("IO Excetpion {}", e.getLocalizedMessage());
			}
		} catch (Exception e) {
			if (logger.isDebugEnabled()) {
				logger.error(e.getLocalizedMessage());
			}
		} finally {
			workbook = null;
			//System.gc();
		}
	}
}
