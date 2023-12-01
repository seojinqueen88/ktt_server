package com.push.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.intra.util.excel.CExcelDocBuild;
import com.push.service.ClientAccesLogTBL_service;

@Controller
public class AccessLog_controller {
	  Logger logger = LoggerFactory.getLogger(AccessLog_controller.class);

	@Autowired
	ClientAccesLogTBL_service clientAccessTbl_Service;
	
	@RequestMapping("accesslog_page.do")
	public ModelAndView accesslog_page(
			@RequestParam(defaultValue = "accesslog", value = "type") String type,
			@RequestParam(defaultValue = "1", value = "page") int page,
			@RequestParam(defaultValue = "req_id", value = "sort") String sort,
			@RequestParam(defaultValue = "desc", value = "direction") String direction,
			@RequestParam(required = false, defaultValue = "0", value = "access_log_type") String access_log_type,
			@RequestParam(required = false, defaultValue = "", value = "mac_address") String mac_address,
			@RequestParam(required = false, defaultValue = "0", value = "search_type") Integer search_type
			//@RequestParam(required = false, defaultValue = "", value = "search_word") String search_word,
			//@RequestParam(required = false, defaultValue ="0" ,value = "search_time_type") String search_time_type
		)	
	{
		ModelAndView mv = new ModelAndView();
		
		List<Map<String, Object>> accesslog_list = null;
		int total = 0;
		int total_list = 0;
		int totalTest = 0;

		switch(type)
		{
		
		case "accesslog_search":
		 
			//String search_word_sql = search_word.trim();
			accesslog_list = clientAccessTbl_Service.select_ClientAccesLogTbl(sort, direction, page, search_type ,mac_address,  clientAccessTbl_Service.getSearchTypeStr(search_type));
			total = accesslog_list.size();
			//total = clientAccessTbl_Service.count_ClientAccesLogTbl( search_type  ,mac_address,  clientAccessTbl_Service.getSearchTypeStr(search_type));
		
			mv.addObject("search_type", search_type);
			mv.addObject("access_log_type", search_type);
			//mv.addObject("search_word", search_word);
			break;
		 
		case "accesslog":
		default:
		   /*
			accesslog_list = clientAccessTbl_Service.select_ClientAccesLogTbl(sort, direction, page, Integer.parseInt(access_log_type) ,mac_address,  null);		    			
			total_list = accesslog_list.size();
		    //totalTest = clientAccessTbl_Service.count_ClientAccesLogTbl(Integer.parseInt(access_log_type) , Integer.parseInt(access_log_type) > 0 ? mac_address :"",  null);
			total = clientAccessTbl_Service.count_ClientAccesLogTbl(Integer.parseInt(access_log_type) , mac_address , null);
			total = clientAccessTbl_Service.count_ClientAccesLogTBL_all(mac_address , null);
*/     
				if(Integer.parseInt(access_log_type) == 5)
				{
					logger.info("222222222222222222222222222222222222222222222");
					accesslog_list = clientAccessTbl_Service.select_ClientAccesLogTBL_all(sort, direction, page, mac_address,  null);
					total = clientAccessTbl_Service.count_ClientAccesLogTBL_all(mac_address , null);
					mv.addObject("access_log_type", access_log_type);
					mv.addObject("search_type", search_type);
				}
			
				else 
				{
					logger.info("1111111111111111111111111111111111111111");
					accesslog_list = clientAccessTbl_Service.select_ClientAccesLogTbl(sort, direction, page, Integer.parseInt(access_log_type), mac_address,  null);		    			
					total = clientAccessTbl_Service.count_ClientAccesLogTbl(Integer.parseInt(access_log_type), mac_address , null);
					mv.addObject("access_log_type", access_log_type);
					mv.addObject("search_type", search_type);
				}
			break;	
		}
		
		logger.info("access_log_type " + access_log_type);
		logger.info("accesslog_list : "+ accesslog_list);
		logger.info("search_type : "+ search_type);
		
		logger.info("page : "+ page);

		int last_page = 0;
		if(total % 10 == 0)
		{
			last_page = total / 10;

		}
		else
		{
			last_page = total / 10 + 1;

		}
        logger.info( "total : " + total );
        logger.info( "total_list : " + total_list );
        logger.info( "totalTest : " + totalTest );
        logger.info( "current_page : " + page);
        logger.info( "start_page : " + (page - 1) / 10 * 10 + 1);
        logger.info( "last_page : " + last_page );

        
        
		mv.setViewName("accesslog");
		mv.addObject("accesslog_list", accesslog_list);
		mv.addObject("direction", direction);
		mv.addObject("type", type);
		mv.addObject("sort", sort);
		mv.addObject("current_page", page);
		mv.addObject("start_page", (page - 1) / 10 * 10 + 1);
		mv.addObject("end_page", (page - 1) / 10 * 10 + 10);
		mv.addObject("last_page", last_page);
		mv.addObject("mac_address", mac_address);

		//mv.addObject("search_time_type", search_time_type);
		return mv;
	
	}
	@RequestMapping("accesslog_excel.xlsx")
    public ModelAndView accesslog_excel(
            @RequestParam(defaultValue = "accesslog", value = "type") String type,
            @RequestParam(defaultValue = "1", value = "page") int page,
            @RequestParam(defaultValue = "req_id", value = "sort") String sort,
            @RequestParam(defaultValue = "desc", value = "direction") String direction,
            @RequestParam(required = false, defaultValue = "0", value = "access_log_type") String access_log_type,
            @RequestParam(required = false, defaultValue = "", value = "mac_address") String mac_address,
            @RequestParam(required = false, defaultValue = "0", value = "search_type_excel") Integer search_type_excel
            //@RequestParam(required = false, defaultValue = "", value = "search_word_excel") String search_word_excel,
            //@RequestParam(required = false, defaultValue ="0" ,value = "search_time_type") String search_time_type
        )   
    {
	    ModelAndView mv = new ModelAndView();
    	int offset = 0;
        int total = 0;
        final String labels[] = {"No" , "ACCESS_LOG_TYPE" , "맥 주소" , "ID or DEVIEC/WEB" , "API 타입" , "DATE"};
        final int columnWidth[] = {10, 30, 30, 50, 50, 50};
        
        CExcelDocBuild excelBuilder = new CExcelDocBuild(labels, columnWidth , "Access Log");
        List<Map<String, Object>> accesslog = null;
        long time = System.currentTimeMillis();
        SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
        String str = type + dayTime.format(new Date(time));
        String fileName = "[" + str +"]" + ".xlsx";
        
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
            //e.printStackTrace();
            //logger.debug(e.getLocalizedMessage());
        }

        // response.setContentType("application/octect-stream; charset=utf-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + fileName + "\";");

        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        // response.setHeader("Content-Transfer-Encoding", "binary");
        response.setHeader("Pragma", "public");
        response.setHeader("Expires", "0");
        response.setHeader("Cache-Control",
                "no-cache, no-store, must-revalidate");
        response.setHeader("Set-Cookie", "fileDownload=true; path=/");
        
        switch(type)
        { 
      	case "accesslog_all":
			while ((accesslog = clientAccessTbl_Service.select_ClientAccesLogTblAll_Excel(sort, direction, page, -1, Integer.parseInt(access_log_type), mac_address,  null)) != null
					&& accesslog.size() > 0)
			{
				offset += 100000;
				excelBuilder.addRowList(accesslog);
			}
	        logger.info( "accesslog_all" );
			break;
			
        case "accesslog":
        default:

        	accesslog = clientAccessTbl_Service.select_ClientAccesLogTblExcel(sort, direction, page, Integer.parseInt(access_log_type), mac_address, null);
        	if(accesslog != null && accesslog.size() > 0)
        	{
        		excelBuilder.addRowList(accesslog);
        	}
	        logger.info( "accesslog" );

        	break;
        }
        
        mv.addObject("dataMap", excelBuilder);
        mv.setViewName("excelXlsx");
        
        
	    return mv;
    }
}
