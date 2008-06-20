<cfcomponent displayName="Appender">
	<cfscript>
		instance = structNew();
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="layout" type="logging.Layout" required="false" />
		<cfset setName( arguments.name ) />
		<cfif not structKeyExists( arguments, 'layout' )>
			<cfset arguments.layout = createObject("component", "logging.layouts.BasicLayout").init() />
		</cfif>
		<cfset setLayout( arguments.layout ) />
		<cfset setLevel( 'all' ) />
		<cfreturn this />
	</cffunction>
	
	<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<cffunction name="write" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />
		<cfthrow type="logging.VirtualMethodError" />
	</cffunction>
	
	<cffunction name="flush" returntype="string" access="public" output="false">
		<cfthrow type="logging.VirtualMethodError" />
	</cffunction>

	<cffunction name="getLevel" access="public" returntype="string" output="false">
		<cfreturn instance.level />
	</cffunction>
	
	<cffunction name="setLevel" access="public" returntype="void" output="false">
		<cfargument name="level" type="string" required="true" />
		<cfset instance.level = arguments.level />
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getLayout" access="private" returntype="logging.Layout" output="false">
		<cfreturn instance.layout />
	</cffunction>
	
	<cffunction name="setLayout" access="private" returntype="void" output="false">
		<cfargument name="layout" type="logging.Layout" required="true" />
		<cfset instance.layout = arguments.layout />
	</cffunction>
	
	<cffunction name="getName" access="private" returntype="string" output="false">
		<cfreturn instance.name />
	</cffunction>
	
	<cffunction name="setName" access="private" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset instance.name = arguments.name />
	</cffunction>
	
</cfcomponent>