package com.push.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;
import com.intra.util.excel.CExcelDocBuild;
import com.push.service.Users_service;
import com.push.util.Encryption;
 

@Controller
public class Users_controller {
	//private static final int SEARCHTYPE_REGISTERTYPE = 5;
	Logger logger = LoggerFactory.getLogger(Users_controller.class);
	
	public static Boolean bStartExcelDown = false;
	
	Logger otp_change_log = LoggerFactory.getLogger("otp_change_log"); // Pushadmin 관리자 페이지를 통한 수정 한 ID 등을 기록하기 위함...
	
	@Autowired
	private Users_service users_service;
	/**
     * 봇 크롤링 막기
     */
    @RequestMapping(value = "/robots.txt")
    @ResponseBody
    public void robotsBlock(HttpServletRequest request, HttpServletResponse response) {
        try {
            response.getWriter().write("User-agent: *\nDisallow: /\n");
        } catch (IOException e) {
          logger.info("exception", e);
        }
    }
	@RequestMapping("serverinfo.do")
	@ResponseBody
	public Map<String, Object> serverinfo() {
		// System.out.println(new Date() +" PUSH SERVER SERVICE INFO");
		logger.info(" PUSH SERVER SERVICE INFO");
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHH");
		Calendar calendar = Calendar.getInstance();
		String currentTime = simpleDateFormat.format(calendar.getTime());
		String hash_key = Encryption.sha256(currentTime);

		Map<String, Object> response = new HashMap<>();
		response.put("hash_key", hash_key);
		logger.info(" PUSH SERVER RESPONSE {} ", response.toString());
		// System.out.println(new Date() + " PUSH SERVER RESPONSE : " +
		// response.toString());
		currentTime = null;
		hash_key = null;
		return response;
	}

	@RequestMapping(value = {"ddns_page.do", "ddns_serviceno.do"})
	public ModelAndView ddns_page(HttpServletRequest request,
			@RequestParam(defaultValue = "ddns_page.do", value = "url") String url,
			@RequestParam(defaultValue = "ddns", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "empty1", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type") int search_type,
			@RequestParam(required = false, defaultValue = "", value = "search_word") String search_word,
			@RequestParam(required = false, defaultValue = "", value = "auth") String auth,
			@RequestParam(required = false, defaultValue = "", value = "service_no") String service_no) {
		ModelAndView mv = new ModelAndView();
		RequestAttributes requestAttributes = RequestContextHolder
				.getRequestAttributes();
		HttpServletResponse httpServelResponse = ((ServletRequestAttributes) requestAttributes)
				.getResponse();
		httpServelResponse.setHeader("Cache-Control", "max-age=60"); 
		
		if (request.getServletPath().equals("/ddns_serviceno.do")) {
			if (auth == null || auth.length() == 0 || service_no == null
					|| service_no.length() == 0
					|| !Encryption.isAvailableKey(service_no, auth)) {
				mv.setViewName("error_page");
				return mv;
			}

			url = "ddns_serviceno.do";
			if (!type.equals("ddns_serviceno")
					&& !type.equals("ddns_serviceno_search"))
				type = "ddns_serviceno";
			mv.addObject("auth", auth);
			mv.addObject("service_no", service_no);
		}

		List<Map<String, Object>> ddns_list = null;
		//int total = 0;
		long total = 0;
		String search_word_sql = "";
		 try {
		switch (type) {
			case "ddns_serviceno_search" :
			  
			  switch(search_type)
			  {
			    case Users_service.SEARCHTYPE_REGISTERTYPE:
			    case Users_service.SEARCHTYPE_OTP_YN:
			    //case Users_service.SEARCHTYPE_APP_ACCESS_TYPE:
			      ddns_list = users_service.select_users_where_serviceno_and_registertype(service_no, search_type,Integer.parseInt(search_word), sort, direction, page);
			    break;
			    
			    /*
			    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER:
                ddns_list = users_service.select_users_where_serviceno_and_search_type(service_no ,  search_type, "장비 (0)", sort, direction, page);
                break;
                case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER:
                ddns_list = users_service.select_users_where_serviceno_and_search_type(service_no,  search_type, "웹뷰어(1)", sort, direction, page);
                break;
                  */
			      
			    default:
			    	search_word_sql = search_word;
                    ddns_list = users_service.select_users_where_serviceno_and_search_type(service_no, search_type, search_word_sql,sort, direction, page);
                    break;
                    }
			  /*
			  if (search_type == Users_service.SEARCHTYPE_REGISTERTYPE) {
				  try {
					  ddns_list = users_service.select_users_where_serviceno_and_registertype(service_no, search_type, Integer.parseInt(search_word), sort, direction, page);
					  total = users_service.count_users_where_serviceno_and_registertype(service_no, search_type, Integer.parseInt(search_word));
					  } 
					catch (NumberFormatException e) {
					}
				  } else {
					search_word_sql = search_word;
					ddns_list = users_service.select_users_where_serviceno_and_search_type(service_no, search_type, search_word_sql,sort, direction, page);
					total = users_service.count_users_where_serviceno_and_search_type(service_no, search_type, search_word_sql);
				}
				*/
				mv.addObject("search_type", search_type);
				mv.addObject("search_word", search_word);
				
				break;

			case "ddns_serviceno" :
				ddns_list = users_service.select_users_where_serviceno(service_no, sort, direction, page);
				//total = users_service.count_users_where_serviceno(service_no);
				break;
			case "ddns_search" :
			    
			  switch(search_type)
			  {
			    case Users_service.SEARCHTYPE_REGISTERTYPE:
			    case Users_service.SEARCHTYPE_OTP_YN:
	//		    case Users_service.SEARCHTYPE_APP_ACCESS_ID:
   //             case Users_service.SEARCHTYPE_CMS_ACCESS_ID: 
                  ddns_list = users_service.select_users_where_registertype(search_type, Integer.parseInt(search_word), sort,direction, page);
                  break;
                
			    /*
			    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER:
                  ddns_list = users_service.select_users_where_search_type(
                      search_type, "장비 (0)", sort, direction,
                      page);
                  break;
                case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER:
                  ddns_list = users_service.select_users_where_search_type(
                      search_type, "웹뷰어(1)", sort, direction,
                      page);
                  break;
                  */
                  default:
                    search_word_sql = search_word;
                    ddns_list = users_service.select_users_where_search_type(search_type, search_word_sql, sort, direction, page); 
                }
			   //  total =  Integer.parseInt(String.valueOf(ddns_list.get(0).get("count")));
			 
              /*
				if (search_type == Users_service.SEARCHTYPE_REGISTERTYPE) {
					try {
						ddns_list = users_service.select_users_where_registertype(search_type, Integer.parseInt(search_word), sort, direction, page);
						total = users_service.count_users_where_registertype(search_type, Integer.parseInt(search_word));
					} catch (NumberFormatException e) {
					}
				} else {
					search_word_sql = search_word;
					ddns_list = users_service.select_users_where_search_type(search_type, search_word_sql, sort, direction, page);
					total = users_service.count_users_where_search_type(search_type, search_word_sql);
				}
				*/
				mv.addObject("search_type", search_type);
				mv.addObject("search_word", search_word);
				break;
			
			case "ddns_search_otp_yn" :
				if (search_type == Users_service.SEARCHTYPE_OTP_YN) {
					 
						ddns_list = users_service.select_users_where_registertype(search_type, Integer.parseInt(search_word), sort, direction, page);
					//	total = users_service.count_users_where_registertype(
					//			search_type, Integer.parseInt(search_word));
					 
				} else {
					search_word_sql = search_word;
					ddns_list = users_service.select_users_where_search_type(search_type, search_word_sql, sort, direction, page);
				//	total = users_service.count_users_where_search_type(
				//			search_type, search_word_sql);
				}

				mv.addObject("search_type", search_type);
				mv.addObject("search_word", search_word);

				break;
				
			case "ddns" :
			default :
				ddns_list = users_service.select_users_all(sort, direction, page);
				//total = users_service.count_users_all();
				//   System.out.println(ddns_list.get(0).get("count").getClass().getName());
				 //if(ddns_list != null)
				 //    total =  Integer.parseInt(String.valueOf(ddns_list.get(0).get("count")));
				//logger.info("page : "+ page);
				
				break;
		}
		if(ddns_list != null && ddns_list.size()>0)
		 total =  Integer.parseInt(String.valueOf(ddns_list.get(0).get("count")));
         } catch (NullPointerException | NumberFormatException e) {
           ddns_list = null;
           total = 0;
         } 
		//int last_page = 0; //int vs long 체크 필요...
		 long last_page = 0; //int vs long 체크 필요...
		int _p;
		if (total % 10 == 0)
			last_page =  (total / 10);
		else
			last_page =  (total / 10 + 1);
		_p = (page - 1) / 10 * 10;
		
		/*
	    logger.info( "total : " + total );
        logger.info( "current_page : " + page);
        logger.info( "start_page : " + (page - 1) / 10 * 10 + 1);
        logger.info( "last_page : " + last_page );      
		*/
		mv.setViewName("ddns");
		mv.addObject("url", url);
		if(ddns_list != null)
		mv.addObject("ddns_list", ddns_list);
		mv.addObject("direction", direction);
		mv.addObject("type", type);
		mv.addObject("sort", sort);
		mv.addObject("current_page", page);
		mv.addObject("start_page", _p + 1);
		mv.addObject("end_page", _p + 10);
		mv.addObject("last_page", last_page);

		return mv;
	}
	@Transactional(readOnly=true)
	@RequestMapping(value = {"ddns_excel.xlsx", "ddns_serviceno_excel.xlsx"})
	public ModelAndView ddns_excel(HttpServletRequest request,
			@RequestParam(defaultValue = "ddns", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "empty1", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "search_type_excel") int search_type_excel,
			@RequestParam(required = false, defaultValue = "", value = "search_word_excel") String search_word_excel,
			@RequestParam(required = false, defaultValue = "", value = "auth") String auth,
			@RequestParam(required = false, defaultValue = "", value = "service_no") String service_no) {
		
		
		
		logger.info("ddns_excel start");
		ModelAndView mv = new ModelAndView();
		final String labels[] = {"No.", "도메인", "제조사", "모델", "외부 IP", "포트", "P2P 라이선스", "P2P 우선순위", "장비 P2P 보유 여부", "등록일", 
				"등록 타입", "IP 갱신", "맥 주소", "장비", "버전", "내부 IP", "웹 포트", "서비스 번호", "서비스 개통 구분", "DDNS 상태", 
				"UPnP", "사원/앱ID", "IP 활성", "OTP 인증" ,"정책획득", "앱정책"};
	
		final int columnWidth[] = {10, 40, 15, 25, 25, 15, 30, 25, 25, 20,
		    25, 30, 30, 15, 20, 30, 15, 25, 15, 20,
		    10, 25, 10, 30, 30, 20,};

		if (request.getServletPath().equals("/ddns_serviceno_excel.xlsx")) {
			if (auth == null || service_no == null
                || auth.length() == 0 ||  service_no.length() == 0
					|| !Encryption.isAvailableKey(service_no, auth)) {
				mv.setViewName("error_page");
				return mv;
			}
		}
		// logger.debug("\n");
		// logger.debug(request.toString());
		// logger.debug("TYPE {}" , type);
		// logger.debug("search_type_excel {} ", search_type_excel);
		CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth, "DDNS");
		Integer num;
		List<Map<String, Object>> ddns_list = null;
		int total =0, offset = 0;
		String search_word_sql = "";
		long time = System.currentTimeMillis();
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String str = "[" + type + "]" + dayTime.format(new Date(time));
		String fileName = str + ".xlsx";
		excelBuilder.createNewSheet(0);
		RequestAttributes requestAttributes = RequestContextHolder
				.getRequestAttributes();
		HttpServletRequest httpServletRequest = ((ServletRequestAttributes) requestAttributes)
				.getRequest();
		HttpServletResponse httpServelResponse = ((ServletRequestAttributes) requestAttributes)
				.getResponse();
		HttpServletResponse response = httpServelResponse;
		// response.setContentType(getContentType());
		response.setBufferSize(512 * 1024);

		excelBuilder.setExcelFileName(str);
		String userAgent = httpServletRequest.getHeader("User-Agent");
		// logger.debug(excelBuilder.getExcelFileName().toString());
		try {
			if (userAgent.indexOf("MSIE") > -1) {

				fileName = URLEncoder.encode(fileName, "utf-8");

			} else {

				fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");

			}
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			// logger.debug(e.getLocalizedMessage());
		}
		response.setHeader("Content-Disposition",
				"attachment; filename=\"" + fileName + "\";");

		// response.setContentType("application/octect-stream; charset=utf-8");
		response.setContentType(
				"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		// response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "public");
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control",
				"no-cache, no-store, must-revalidate");
		try {
			switch (type) {
				case "ddns_serviceno_search_all" :
				  switch(search_type_excel)
				  {
				    case Users_service.SEARCHTYPE_REGISTERTYPE:
	                case Users_service.SEARCHTYPE_OTP_YN:
	                
	                  num = Integer.parseInt(search_word_excel);
                      ddns_list = users_service.select_users_where_serviceno_and_registertype_excel( service_no, search_type_excel, num, sort, direction, -1);
	                  break;
	                  /*
	                case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER:
	                  ddns_list = users_service.select_users_where_serviceno_and_search_type_excel(service_no,  search_type_excel, "장비 (0)", sort, direction, -1);
	                  break;
	                case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER:
	                  ddns_list = users_service.select_users_where_serviceno_and_search_type_excel(service_no, search_type_excel, "웹뷰어(1)", sort, direction, -1);
	                  break;
	                  */
	                  default:
	                    search_word_sql = search_word_excel;
                        ddns_list = users_service.select_users_where_serviceno_and_search_type_excel(service_no, search_type_excel, search_word_sql, sort, direction, -1);
                        break;
				  }
					/*if (search_type_excel == Users_service.SEARCHTYPE_REGISTERTYPE) {
						num = Integer.parseInt(search_word_excel);
						ddns_list = users_service.select_users_where_serviceno_and_registertype_excel(service_no, search_type_excel, num, sort, direction, -1);

					} else {
						search_word_sql = search_word_excel;
						ddns_list = users_service.select_users_where_serviceno_and_search_type_excel(service_no, search_type_excel, search_word_sql, sort, direction, -1);
					}*/
					if (ddns_list != null && ddns_list.size() > 0)
						excelBuilder.addRowList(ddns_list);
					break;
				case "ddns_serviceno_search" :
				  switch(search_type_excel)
                  {
                    case Users_service.SEARCHTYPE_REGISTERTYPE:
                    case Users_service.SEARCHTYPE_OTP_YN:
         
                      num = Integer.parseInt(search_word_excel);
                      ddns_list = users_service.select_users_where_serviceno_and_registertype_excel(service_no, search_type_excel, num, sort, direction, page);
                      break;
                      /*
                    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER:
                      ddns_list = users_service.select_users_where_serviceno_and_search_type_excel(service_no,  search_type_excel, "장비 (0)", sort, direction, page);
                      break;
                    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER:
                      ddns_list = users_service.select_users_where_serviceno_and_search_type_excel(service_no, search_type_excel, "웹뷰어(1)", sort, direction, page);
                      break;
                      */
                     default:
                       search_word_sql = search_word_excel;
                       ddns_list = users_service.select_users_where_serviceno_and_search_type_excel( service_no, search_type_excel, search_word_sql, sort, direction, page);
                       break;
                  }
				/*	if (search_type_excel == Users_service.SEARCHTYPE_REGISTERTYPE) {
						num = Integer.parseInt(search_word_excel);
						ddns_list = users_service.select_users_where_serviceno_and_registertype_excel(service_no, search_type_excel, num, sort, direction, page);

					} else {
						search_word_sql = search_word_excel;
						ddns_list = users_service
								.select_users_where_serviceno_and_search_type_excel(service_no, search_type_excel,search_word_sql, sort, direction, page);
					}*/
					if (ddns_list != null && ddns_list.size() > 0)
						excelBuilder.addRowList(ddns_list);
					break;
				case "ddns_serviceno_all" :
					// total =
					// users_service.count_users_where_serviceno(service_no);
					while ((ddns_list = users_service.select_users_where_serviceno_excel(service_no, sort, direction, offset, -1)) != null 
					&& ddns_list.size() > 0) {
						excelBuilder.addRowList(ddns_list);
						offset += 100000;
					}
					break;
				case "ddns_serviceno" :
					ddns_list = users_service.select_users_where_serviceno_excel(service_no, sort, direction, -1, page);
					if (ddns_list != null && ddns_list.size() > 0)
						excelBuilder.addRowList(ddns_list);
					break;
				case "ddns_search_all" :
				case "ddns_serach_otp_yn_all":
				  switch(search_type_excel)
                  {
                    case Users_service.SEARCHTYPE_REGISTERTYPE:
                    case Users_service.SEARCHTYPE_OTP_YN:
                
                      num = Integer.parseInt(search_word_excel);
                      ddns_list = users_service.select_users_where_registertype_excel(search_type_excel, num, sort, direction,  -1);
                      break;
                      /*
                    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER:
                      ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, "장비 (0)", sort, direction, -1);
                      break;
                    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER:
                      ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, "웹뷰어(1)", sort, direction, -1);
                      break;
                      */
                      default:
                        search_word_sql = search_word_excel;
                        ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, search_word_sql, sort, direction, -1);
                        break;
                  }
				/*	if (search_type_excel == Users_service.SEARCHTYPE_REGISTERTYPE || 
					    search_type_excel == Users_service.SEARCHTYPE_OTP_YN) {
						num = Integer.parseInt(search_word_excel);
						ddns_list = users_service.select_users_where_registertype_excel(search_type_excel, num, sort, direction, -1);

					} else {
						search_word_sql = search_word_excel;
						ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, search_word_sql, sort, direction, -1);
					}*/
					if (ddns_list != null && ddns_list.size() > 0)
						excelBuilder.addRowList(ddns_list);
					break;
				case "ddns_search_otp_yn":
				case "ddns_search" :
				  switch(search_type_excel)
                  {
                    case Users_service.SEARCHTYPE_REGISTERTYPE:
                    case Users_service.SEARCHTYPE_OTP_YN:
                  
                      num = Integer.parseInt(search_word_excel);
                      ddns_list = users_service .select_users_where_registertype_excel(search_type_excel, num, sort, direction, page);
                      break;
                      /*
                    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_RECORDER:
                      ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, "장비 (0)", sort, direction, page);
                      break;
                    case Users_service.SEARCHTYPE_DEVICE_PROTOCOL_FROM_WEBVIEWER:
                      ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, "웹뷰어(1)", sort, direction, page);
                      break;
                      */
                      default:
                        search_word_sql = search_word_excel;
                      ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, search_word_sql, sort, direction, page);
                      break;
                  }
                      /*
                       
					if (search_type_excel == Users_service.SEARCHTYPE_REGISTERTYPE 
					 || search_type_excel == Users_service.SEARCHTYPE_OTP_YN) {
						num = Integer.parseInt(search_word_excel);
						ddns_list = users_service.select_users_where_registertype_excel(search_type_excel, num, sort, direction, page);
					} else {
						search_word_sql = search_word_excel;
						ddns_list = users_service.select_users_where_search_type_excel(search_type_excel, search_word_sql, sort, direction, page);
					}
					*/
					if (ddns_list != null && ddns_list.size() > 0)
						excelBuilder.addRowList(ddns_list);
					break;
				case "ddns_all" : {
					
					if(bStartExcelDown == false)
					{
						bStartExcelDown = true;
						
						logger.info("ddns_all start");
					
						while ((ddns_list = users_service.select_users_all_excel(sort, direction, offset)) != null
								&& ddns_list.size() > 0) 
						{
							offset += 100000;
							logger.info("ddns_all addRowList");
							excelBuilder.addRowList(ddns_list);
							logger.info("ddns_all 100000");
							logger.info("offset : " + offset);
						}
						
						try (ServletOutputStream out = response.getOutputStream()) 
						{ 
							response.setHeader("Content-Type","text/html; charset=utf-8");
							response.setHeader("Set-Cookie", "fileDownload=true; path=/");
							
							excelBuilder.getWorkbook().write(out);
							out.flush();
							out.close();
							
							logger.debug("excel write ok");
						} catch (Exception e) {	 
							response.setHeader("Set-Cookie", "fileDownload=false; path=/");
							response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
							response.setHeader("Content-Type","text/html; charset=utf-8");
							logger.debug(e.getMessage());
						}finally
						{
							excelBuilder.getWorkbook().dispose();
							excelBuilder.getWorkbook().close();
							 
							excelBuilder = null;
							//yglee remove 2023.12.27
							//System.gc();
						}
						
						
						mv.addObject("dataMap", excelBuilder);
						mv.addObject("writeOk", "1");
						mv.setViewName("excelXlsx");

						bStartExcelDown = false;
						logger.info("ddns_all end");
						return null;
					}
					else
					{
						logger.info("already downloading");
						/*
						String msg = "엑셀 다운로드 완료 후 다시 시도 바랍니다.";
						
						response.setContentType("text/html; charset=utf-8");
				        PrintWriter w = response.getWriter();
				        w.write("<script>alert('"+msg+"');</script>");
				        w.flush();
				        response.flushBuffer();
				        w.close();
*/
											
						response.setContentType("text/html; charset=utf-8");
						response.setHeader("Content-Type","text/html; charset=utf-8");
						response.setHeader("Set-Cookie", "fileDownload=false; path=/");
						
						ServletOutputStream out = null;
						
						try {
							out = response.getOutputStream();
							
							byte[] data = new String("fail..").getBytes();
							out.write(data, 0, data.length);
							
						  } catch(Exception ignore) {
							  	response.setHeader("Set-Cookie", "fileDownload=false; path=/");
								response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
								response.setHeader("Content-Type","text/html; charset=utf-8");
						  } finally {
							if(out != null) try { out.close(); } catch(Exception ignore) {}
						  }
						
						return null;
					}
					
					// logger.info(ddns_list.size()+"");
				}
					//break;
			 
				case "ddns" :
				default :
					ddns_list = users_service.select_users_all_excel_current_page(sort, direction, page);
					if (ddns_list != null && ddns_list.size() > 0)
						excelBuilder.addRowList(ddns_list);
					break;
			}

		} catch (NumberFormatException e) {
			logger.debug(e.getLocalizedMessage());
		} catch (Exception e) {
			logger.debug(e.getLocalizedMessage());
		} finally {

		}
	
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		mv.addObject("dataMap", excelBuilder);
		mv.setViewName("excelXlsx");

		return mv;
	}
	
	@RequestMapping(value = {"network_ddns_page.do",
			"network_ddns_serviceno.do"})
	public ModelAndView network_ddns_page(HttpServletRequest request,
			@RequestParam(required = true, value = "url") String url,
			@RequestParam(required = false, defaultValue = "", value = "domain") String domain,
			@RequestParam(required = false, defaultValue = "", value = "mac") String mac,
			@RequestParam(required = false, defaultValue = "", value = "auth") String auth,
			@RequestParam(required = false, defaultValue = "", value = "service_no") String service_no) {
		ModelAndView mv = new ModelAndView();

		if (request.getServletPath().equals("network_ddns_serviceno.do")) {
			if (auth == null || auth.length() == 0 || service_no == null
					|| service_no.length() == 0
					|| !Encryption.isAvailableKey(service_no, auth)) {
				mv.setViewName("error_page");
				return mv;
			}

			mv.addObject("auth", auth);
			mv.addObject("service_no", service_no);
		}

		mv.setViewName("ddns_popup_check_network");
		mv.addObject("url", url);
		mv.addObject("domain", domain);
		mv.addObject("mac", mac);
		return mv;
	}


	@RequestMapping(value = {"chk_otp_yn.do"})
	@ResponseBody
	public int check_otp_yn(HttpServletRequest request,
			@RequestParam(required = false, value = "url") String url,
			@RequestBody Map<String, Object> map) {
		
		if(map.containsKey("mac"))
			return  users_service
				.select_user_registerType_where_otp_yn((String) map.get("mac"));
		else 
			return -1;
	}

	
	@RequestMapping(value = {"chk_service_no.do"})
	@ResponseBody
	public int check_service_no(HttpServletRequest request,
			@RequestParam(required = false, value = "url") String url,
			@RequestBody Map<String, Object> map) {
		String mac = (String) map.get("mac");
		if (mac == null) {
			return -1;
		}
		int registerType = users_service
				.select_user_registerType_where_mac(mac);
//0-신규, 1-설변, 2-유지보수동일교체, 3-AS, 4-일반, 5-고객(영상lib), 6-고객통합앱서버, 7-기존등록
		return registerType;
	}

	/*
	 * 20220525 / 추가 / 서비스 번호 웹 내 수정 기능 추가
	 */
	@RequestMapping(value = {"chk_service_no_modify_page.do"})
	@ResponseBody
	public ModelAndView check_service_no_page(HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "", value = "serviceNo") String serviceNo,
			@RequestParam(required = false, defaultValue = "", value = "mac") String jumin) {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("ddns_service_no_modfy");
		mv.addObject("serviceNo", serviceNo);
		mv.addObject("mac", jumin);

		return mv;
	}
/**
 * 
* @Method Name : modify_opt_yn
* @작성일 : 2022. 11. 28. 
* @작성자 : Foryoucom
* @변경이력 :
* @Method 설명 : OTP_YN 인증 번호 수정 관련 (0/1/2 만 유효
* @param request
* @param serviceNo
* @param jumin
* @return
 */
	@RequestMapping(value = {"/modify_otp_yn.do"})
	@ResponseBody
	public ModelAndView modify_opt_yn(HttpServletRequest request,
	    @RequestParam(required = true, defaultValue = "", value = "mac") String jumin,
	    @RequestParam(required = true, defaultValue = "", value = "otp_yn") String otp_yn,
		@RequestParam(required = true, defaultValue = "", value = "id") String id,
		@RequestParam(required = false, defaultValue = "", value = "before_otp_yn") String before_otp_yn) {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("ddns_modify_otp_yn");
		mv.addObject("otp_yn", otp_yn);
		mv.addObject("mac", jumin);
		mv.addObject("before_otp_yn",before_otp_yn);
		return mv;
	}
	/**
	 * 
	* @Method Name : modify_access_rule
	* @작성일 : 2023. 5. 19. 
	* @작성자 : Foryoucom
	* @변경이력 : 통합 앱 지원 
	* @Method 설명 :
	* @param request
	* @param jumin
	* @param access_rule
	* @param id
	* @param before_access_rule
	* @return
	 */
	@RequestMapping(value = {"/modify_access_rule.do"} , produces = MediaType.APPLICATION_JSON_VALUE )
    @ResponseBody
    public ModelAndView modify_access_rule(HttpServletRequest request,
        @RequestParam(required = true, defaultValue = "", value = "mac") String jumin,
        @RequestParam(required = true, defaultValue = "", value = "access_rule") String access_rule,
        @RequestParam(required = true, defaultValue = "", value = "id") String id,
        @RequestParam(required = false, defaultValue = "", value = "before_access_rule") String before_access_rule) {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("ddns_modify_access_rule");
        mv.addObject("access_rule", access_rule);
        mv.addObject("mac", jumin);
        mv.addObject("before_access_rule",before_access_rule);
        return mv;
    }
	
	@RequestMapping(value = "ddns_service_no_modify.do")
	@ResponseBody
	public String ddns_service_no_modify(
			@RequestParam(defaultValue = "ddns_page.do", value = "url") String url,
			@RequestBody Map<String, Object> map) {
		String jumin = (String) map.get("mac");
		String serviceNo = (String) map.get("serviceNo");
		String empNo = (String) map.get("empNo");

		String modify_serviceNo = users_service
				.update_service_no_where_mac(jumin, serviceNo, empNo);

		return modify_serviceNo;
	}
	
	@RequestMapping(value = "ddns_service_opt_yn_modify.do")
	@ResponseBody
	public String ddns_service_opt_yn_modify(
			@RequestParam(defaultValue = "ddns_page.do", value = "url") String url,
			@RequestBody Map<String, Object> map) {
		
		if(map.containsKey("opt_yn") == false || map.containsKey("id") ==false)
			return "parameter_err";
		String jumin = (String) map.get("mac");
        String id = (String) map.get("id");
		Integer otp_yn = (Integer) map.get("opt_yn");
		//String empNo = (String) map.get("empNo");
		//System.out.println("OPTY %d\n" + opt_yn );
		//System.out.println("jumin %d\n" + jumin );
	 
		if(map.containsKey("before_otp_yn"))
		{
		  otp_change_log.info(" OTP_ADMIN_ID: {}mac: {}, OTP_YN: {}->{}",id,jumin,map.get("before_otp_yn"),otp_yn);
		}else
		{//TRACE  <  DEBUG  <  INFO  <  WARN  <  ERROR
		  otp_change_log.error(" OTP_ADMIN_ID: {} mac: {},OTP_YN: {}" ,id,jumin ,otp_yn);
		}
		if(users_service.update_users_service_no_otp_yn(id,jumin, otp_yn) == true)
		{
			return "success";
		}
		else  
		{
			return "failed";
		}
		  
	}
	// END

	//
/**
 * 
* @Method Name : ddns_service_access_rule_modi_modify
* @작성일 : 2023. 5. 19. 
* @작성자 : Foryoucom
* @변경이력 :
* @Method 설명 :
* @param url
* @param map
* @return
 */
    @RequestMapping(value = "ddns_service_access_rule_modi_modify.do" /*, produces = MediaType.APPLICATION_JSON_VALUE*/)
    @ResponseBody
    public String ddns_service_access_rule_modi_modify(
            @RequestParam(defaultValue = "ddns_page.do", value = "url") String url,
            @RequestBody Map<String, Object> map) {
        
        if(map.containsKey("access_rule") == false || map.containsKey("id") ==false)
            return "parameter_err";
        String jumin = (String) map.get("mac");
        String id = (String) map.get("id");
        Integer access_rule = (Integer) map.get("access_rule");
 
        if(map.containsKey("before_access_rule"))
        {
          otp_change_log.info(" 통합 앱 - ADMIN_ID: {}mac: {}, access_rule: {}->{}",id,jumin,map.get("before_access_rule"),access_rule);
        }else
        {//TRACE  <  DEBUG  <  INFO  <  WARN  <  ERROR
          otp_change_log.error(" 통합 앱 - ADMIN_ID: {} mac: {},access_rule: {}" ,id,jumin ,access_rule);
        }
        if(users_service.update_users_service_no_access_rule(id,jumin, access_rule) == true)
        {
            return "success";
        }
        else  
        {
            return "failed";
        }
          
    }
	
	
	// ddns 상태 정보 변경 페이지
	@RequestMapping("check_ddns_service_page.do")
	public ModelAndView check_modify_page(HttpServletRequest request,
			@RequestParam(required = true, value = "url") String url,
			@RequestParam(required = false, defaultValue = "", value = "domain") String domain,
			@RequestParam(required = false, defaultValue = "", value = "mac") String mac,
			@RequestParam(required = false, defaultValue = "", value = "service_user") String service_user) {
		ModelAndView mv = new ModelAndView();

		if (request.getServletPath().equals("check_ddns_service_page.do")) {
			if (mac == null || mac.length() == 0 || domain == null
					|| domain.length() == 0 || service_user == null
					|| service_user.length() == 0) {
				mv.setViewName("error_page");
				return mv;
			}
			mv.setViewName("check_ddns_service_page");

		} else if (request.getServletPath()
				.equals("check_ddns_service_modify_page.do")) {
			if (mac == null || mac.length() == 0 || domain == null
					|| domain.length() == 0 || service_user == null
					|| service_user.length() == 0) {
				mv.setViewName("error_page");
				return mv;
			}
			return mv;
		}
		mv.addObject("url", url);
		mv.addObject("domain", domain);
		mv.addObject("mac", mac);
		mv.addObject("service_user", service_user);
		return mv;
	}

	@RequestMapping("check_ddns_service_modify_page.do")
	@ResponseBody
	public String check_ddns_service_modify_page(HttpServletRequest request,
			@RequestParam(defaultValue = "ddns_page.do", value = "url") String url,
			@RequestBody Map<String, Object> map) {
		String domain = (String) map.get("domain");
		String mac = (String) map.get("mac");
		// String serviceUser = (String)map.get("service_user");
		int service_user = Integer.parseInt((String) map.get("service_user"));
		String modifyResult = null;
		if (mac == null || mac.length() == 0 || domain == null
				|| domain.length() == 0) {

			return "failed";
		}

		int modifyServiceUser = users_service.update_service_user_where_mac(mac,
				service_user);
		if (modifyServiceUser == 1) {
			modifyResult = "success";
		} else if (modifyServiceUser == 0) {
			modifyResult = "failed";
		} else {
			modifyResult = "checked";
		}
		return modifyResult;
	}

	@RequestMapping(value = "push_ddns_user_delete_service.do")
	@ResponseBody
	public String ddns_device_delete_service(HttpServletRequest request,
			@RequestParam(defaultValue = "ddns_page.do", value = "url") String url,
			@RequestBody Map<String, Object> map) {
		String result = "error";
		int delete_result = 0;
		// int cnt = Integer.parseInt((String)map.get("cnt"));
		@SuppressWarnings("unchecked")
		ArrayList<String> ddnsArr = (ArrayList<String>) map.get("mac");

		for (int i = 0; i < ddnsArr.size(); i++) {
			String ddns_list = (String) ddnsArr.get(i).replaceAll(" ", "");
			if (ddns_list.length() != 17) {
				return "failed-length";
			}
			delete_result = users_service
					.delete_ddns_where_domain_jumin(ddns_list);
			if (delete_result == 0) {
				return "failed";
			} else if (delete_result == 1) {
				result = "success";
			} else {
				return "checked";
			}
		}

		return result;
	}

	@RequestMapping(value = {"check_network.do",
			"check_network_ddns_serviceno.do"})
	@ResponseBody
	public Map<String, Object> check_network(
			@RequestBody Map<String, Object> request) {
		boolean clientport_result = false;
		boolean webport_result = false;
		boolean ping_result = false;

		do {
			try {
				String mac = (String) request.get("mac");
				if (mac == null || mac.length() == 0)
					break;

				Map<String, Object> device = users_service
						.select_users_network_where_mac(mac);
				if (device == null)
					break;

				String addr = (String) device.get("addr");
				if (addr.length() == 0)
					break;

				int clientport = 0;
				if (((String) device.get("port")).length() > 0)
					clientport = Integer.parseInt((String) device.get("port"));
				int webport = 0;
				if (((String) device.get("webport")).length() > 0)
					webport = Integer.parseInt((String) device.get("webport"));

				boolean port_result = false;
				if (clientport != 0
						&& Encryption.availablePort(addr, clientport)) {
					clientport_result = true;
					port_result = true;
				}
				if (webport != 0 && Encryption.availablePort(addr, webport)) {
					webport_result = true;
					port_result = true;
				}
				if (port_result)
					break;

				InetAddress pingcheck = InetAddress.getByName(addr);
				if (pingcheck.isReachable(2000))
					ping_result = true;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} while (false);

		Map<String, Object> response = new HashMap<>();
		response.put("clientport_result", clientport_result);
		response.put("webport_result", webport_result);
		response.put("ping_result", ping_result);

		return response;
	}

	@RequestMapping(value = {"check_p2p.do", "check_p2p_ddns_serviceno.do"})
	@ResponseBody
	public Map<String, Object> check_p2p(
			@RequestBody Map<String, Object> request) {
		Map<String, Object> response = new HashMap<>();
		response.put("p2p_uid", "");
		response.put("p2p_priority", 0);
		response.put("p2p_device", 0);

		do {
			String mac = (String) request.get("mac");
			if (mac == null || mac.length() == 0)
				break;

			Map<String, Object> p2p = users_service
					.select_users_p2p_where_mac(mac);
			if (p2p == null)
				break;

			response.put("p2p_uid", (String) p2p.get("p2p_uid"));
			response.put("p2p_priority", (int) p2p.get("p2p_priority"));
			response.put("p2p_device", (int) p2p.get("p2p_device"));
		} while (false);

		return response;
	}

	@RequestMapping("update_p2p_priority.do")
	@ResponseBody
	public String update_p2p_priority(
			@RequestBody Map<String, Object> request) {
		String p2p_uid = (String) request.get("p2p_uid");
		String p2p_priority = (String) request.get("p2p_priority");

		if (p2p_uid == null || p2p_priority == null)
			return "fail";

		if (!users_service.update_users_p2ppriority_where_p2puid(p2p_uid,
				Integer.parseInt(p2p_priority)))
			return "fail";

		return "success";
	}
}
