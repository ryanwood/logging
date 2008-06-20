<cfcomponent displayname="FileAppender" extends="logging.Appender" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="file" type="string" required="true" />
		<cfargument name="layout" type="logging.Layout" required="false" />
		<cfscript>
			super.init( argumentCollection = arguments );
			instance.file = arguments.file;
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
		
	<cffunction name="write" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />
		<cffile action="append" file="#instance.file#" output="#getLayout().format( arguments.event )#" addnewline="true" />	
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>