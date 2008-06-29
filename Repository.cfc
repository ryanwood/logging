<cfcomponent displayname="logging.Repository" output="false">
	<cfscript>
		instance = structNew();
		PATH_DELIMITER = '::';
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfset instance.repo = structNew() />
		<cfreturn this />
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->		
	
	<cffunction name="addLogger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="logger" type="logging.Logger" required="true"/>
		<cfset instance.repo[ arguments.name ] = arguments.logger /> 
	</cffunction>
	
	<cffunction name="getLogger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn instance.repo[ arguments.name ] />
	</cffunction>

	<cffunction name="hasLogger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn structKeyExists( instance.repo, arguments.name ) />
	</cffunction>
	
	<cffunction name="parent" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<!--- <cfreturn structKeyExists( instance.repo, arguments.name ) /> --->
	</cffunction>
	
	<cffunction name="children" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<!--- <cfreturn structKeyExists( instance.repo, arguments.name ) /> --->
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>