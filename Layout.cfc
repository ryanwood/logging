<cfcomponent displayName="Layout">
	<cfscript>
		instance = structNew();
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfreturn this />
	</cffunction>
	
	<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<cffunction name="format" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />
		<cfthrow type="logging.VirtualMethodError" />
	</cffunction>	
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	

	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="formatNow" returntype="string" output="false" access="private">
		<cfargument name="now" type="date" required="false" default="#now()#" />
		<cfreturn "#dateFormat( arguments.now, 'yyyy-mm-dd' )# #timeFormat( arguments.now, 'HH:mm:ss.l' )#" />
	</cffunction>
			
	<cffunction name="newLine" output="false" access="private">
		<cfif not structKeyExists( instance, 'lineSeparator' )>
			<cfset instance.lineSeparator = createObject("java", "java.lang.System").getProperty("line.separator") />
		</cfif>
		<cfreturn instance.lineSeparator />
	</cffunction>
	
</cfcomponent>