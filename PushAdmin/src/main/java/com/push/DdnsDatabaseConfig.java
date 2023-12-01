package com.push;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan(value="com.ddns.dao", sqlSessionFactoryRef="ddnsSqlSessionFactory")
public class DdnsDatabaseConfig
{
	@Bean(name="ddnsDataSourcet")
	@ConfigurationProperties(prefix="spring.ddns.datasource")
	public DataSource ddnsDataSource()
	{
		return DataSourceBuilder.create().build();
	}

	@Bean(name="ddnsSqlSessionFactory")
	public SqlSessionFactory ddnsSqlSessionFactory(@Qualifier("ddnsDataSourcet") DataSource ddnsDataSource, ApplicationContext applicationContext) throws Exception
	{
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(ddnsDataSource);
		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:com/ddns/mapper/postgresql/*.xml"));
		sqlSessionFactoryBean.setTypeAliasesPackage("com.ddns.model");
		return sqlSessionFactoryBean.getObject();
	}

	@Bean(name="ddnsSqlSessionTemplate")
	public SqlSessionTemplate ddnsSqlSessionTemplate(SqlSessionFactory ddnsSqlSessionFactory) throws Exception
	{
		return new SqlSessionTemplate(ddnsSqlSessionFactory);
	}
}
