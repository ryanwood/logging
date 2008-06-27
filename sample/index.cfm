<cfset beanFactory = createObject( "component", "coldspring.beans.DefaultXmlBeanFactory" ).init() />
<cfset beanFactory.loadBeansFromXmlFile("coldspring.xml", true) />

<cfset logger = beanFactory.getBean( "Logger" ) />

<cfdump var="#logger.getName()#" />