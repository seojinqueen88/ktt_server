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
import org.springframework.context.annotation.Primary;

@Configuration
@MapperScan(value="com.push.dao", sqlSessionFactoryRef="pushSqlSessionFactory")
public class PushDatabaseConfig
{
	@Bean(name="pushDataSourcet")
	@Primary
	@ConfigurationProperties(prefix="spring.push.datasource")
	public DataSource pushDataSource()
	{
		return DataSourceBuilder.create().build();
	}

	@Bean(name="pushSqlSessionFactory")
	@Primary
	public SqlSessionFactory pushSqlSessionFactory(@Qualifier("pushDataSourcet") DataSource pushDataSource, ApplicationContext applicationContext) throws Exception
	{
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(pushDataSource);
		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:com/push/mapper/postgresql/*.xml"));
		sqlSessionFactoryBean.setTypeAliasesPackage("com.push.model");
		return sqlSessionFactoryBean.getObject();
	}

	@Bean(name="pushSqlSessionTemplate")
	@Primary
	public SqlSessionTemplate pushSqlSessionTemplate(SqlSessionFactory pushSqlSessionFactory) throws Exception
	{
		return new SqlSessionTemplate(pushSqlSessionFactory);
	}
}
