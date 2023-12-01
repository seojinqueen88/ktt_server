package com.push.util;

import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.LocalizedResourceHelper;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.servlet.view.AbstractView;
/**
 * 
* @FileName : ExcelCustomView.java
* @Project : PushAdmin
* @Date : 2022. 9. 5. 
* @작성자 : Foryoucom
* @변경이력 :
* @프로그램 설명 :XSSFWorkbook Library를 이용한 엑셀 파일 생성 프로그램, 해당 라이브러리를 사용 할 경우 메모리에 임시적으로 엑셀을 생성 후 출력하는 구조로 되어 있음
* 라이브러리는 읽기 , 쓰기 모드 두 가지를 모두 지원함. 
* 
 */
public abstract class ExcelCustomView extends AbstractView {

	/** The content type for an Excel response */
	private static final String CONTENT_TYPE = "application/vnd.ms-excel";

	/** The extension to look for existing templates */
	private static final String EXTENSION = ".xlsx";


	private String url;

	public ExcelCustomView() {
		setContentType(CONTENT_TYPE);
	}
	
	public void setUrl(String url) {
		this.url = url;
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		XSSFWorkbook workbook;
		if (this.url != null) {
			workbook = getTemplateSource(this.url, request);
		}
		else {
			workbook = new XSSFWorkbook();
			logger.debug("Created Excel Workbook from scratch");
		}

		// 기존의 xlsx 다운로드 방식(workbook
		buildExcelDocument(model, workbook, request, response);
		
		response.setContentType(getContentType());
				
		ServletOutputStream out = response.getOutputStream();
		workbook.write(out);
		out.flush();

	}

	protected XSSFWorkbook getTemplateSource(String url, HttpServletRequest request) throws Exception {
		LocalizedResourceHelper helper = new LocalizedResourceHelper(getApplicationContext());
		Locale userLocale = RequestContextUtils.getLocale(request);
		Resource inputFile = helper.findLocalizedResource(url, EXTENSION, userLocale);
		
		if (logger.isDebugEnabled()) {
			logger.debug("Loading Excel workbook from " + inputFile);
		}
		
		return new XSSFWorkbook(inputFile.getInputStream());
	}
	
	protected abstract void buildExcelDocument(
			Map<String, Object> model, XSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response)
			throws Exception;
	
		
}