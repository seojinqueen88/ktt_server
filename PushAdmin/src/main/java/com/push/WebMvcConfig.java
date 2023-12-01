package com.push;

import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

import com.push.util.LoginCheckInterceptor;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer
{
	@Autowired
	private LoginCheckInterceptor loginCheckInterceptor;
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
	    registry.addResourceHandler( "/*.css", "/*.ttf", "/*.woff", "/*.woff2", "/*.eot","/*.svg","/*.png","/*.jpg")
        .addResourceLocations("classpath:/static/")
        .setCacheControl(CacheControl.maxAge(120, TimeUnit.SECONDS)
                .cachePrivate()
                .mustRevalidate())
        .resourceChain(true)
        .addResolver(new PathResourceResolver());
	    }
	@Override
	public void addInterceptors(InterceptorRegistry registry)
	{
		registry.addInterceptor(loginCheckInterceptor)
				.addPathPatterns("/**/*")
				.excludePathPatterns("/main.do")
				.excludePathPatterns("/login_check.do")
				.excludePathPatterns("/logout.do")
				.excludePathPatterns("/serverinfo.do")
				.excludePathPatterns("/ddns_serviceno.do")
				.excludePathPatterns("/ddns_serviceno_excel.xlsx")
				.excludePathPatterns("/network_ddns_serviceno.do")
				.excludePathPatterns("/check_network_ddns_serviceno.do")
				.excludePathPatterns("/check_p2p_ddns_serviceno.do")
				.excludePathPatterns("/add_p2p_ddns_serviceno.do")
				.excludePathPatterns("/img/loading.gif")
				.excludePathPatterns("/chk_service_no_modify_page.do")
				.excludePathPatterns("/ddns_service_no_modify.do");
	}
}
