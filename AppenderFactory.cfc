<cfcomponent displayname="AppenderFactory" output="false">
	<cfscript>
		instance = structNew();
	</cfscript>
	
	<cffunction name="init" access="public" output="false" hint="Singleton Appender Factory">
		<cfscript>
			instance.repo = structNew();
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->		
	
	<cffunction name="getAppender" output="false" access="public">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="layoutName" type="string" required="false" default="Basic" />
		<cfset var appender = '' />
		<cfset var layout = '' />
		
		<cfif appenderExists( arguments.name )>
			<cfset appender = instance.repo[ arguments.name ] />
		<cfelse>
			<cfset layout = createObject( "component", "logging.layouts." & arguments.layoutName ).init() />		
			<cfset appender = createObject( "component", "logging.appenders." & arguments.type ).init( layout ) />
			<cfset addAppender( arguments.name, appender ) />
		</cfif>		
		<cfreturn appender />		
	</cffunction>	
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="addAppender" access="private" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="appender" type="logging.Appender" required="true"/>
		<cfset instance.repo[ arguments.name ] = arguments.appender /> 
	</cffunction>	

	<cffunction name="appenderExists" access="private" output="false">
		<cfargument name="name" type="string" required="true"/>		
		<cfreturn structKeyExists( instance.repo, arguments.name ) />
	</cffunction>	
	
</cfcomponent>