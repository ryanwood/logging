<cfcomponent displayname="LoggerFactory" output="false">
	<cfscript>
		instance = structNew();
	</cfscript>
	
	<cffunction name="init" access="public" output="false" hint="Singleton Logger Factory">
		<cfargument name="levels" type="string" required="false" default="debug,info,warn,error,fatal" />
		<cfscript>
			setLevels( arguments.levels );
			setRepository( createObject("component", "logging.Repository").init() );
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->		
	
	<cffunction name="getLogger" returntype="logging.Logger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfset var logger = 0 />
		<cfif getRepository().hasLogger( arguments.name )>
			<cfset logger = getRepository().getLogger( arguments.name ) />
		<cfelse>
			<cfset logger = createObject("component", "logging.Logger").init( arguments.name ) />
			<cfset logger.configure( getLevels() ) />
			<cfset getRepository().addLogger( arguments.name, logger ) />
		</cfif>
		<cfreturn logger />
	</cffunction>
	
	<cffunction name="getLevels" output="false" access="public">
		<cfreturn instance.levels />
	</cffunction>
	
	<cffunction name="setLevels" output="false" access="public">
		<cfargument name="levels" type="string" required="true" hint="a list of levels from wide to narrow"/>
		<cfset instance.levels = arguments.levels />
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getRepository" access="private" output="false">
		<cfreturn instance.repository />
	</cffunction>
	
	<cffunction name="setRepository" access="private" output="false">
		<cfargument name="repository" type="logging.Repository" required="true" />
		<cfset instance.repository = arguments.repository />
	</cffunction>
	
</cfcomponent>