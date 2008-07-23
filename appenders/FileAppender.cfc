<cfcomponent displayname="FileAppender" extends="logging.Appender" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="file" type="string" required="true" />
		<cfargument name="layout" type="logging.Layout" required="false" />
		<cfscript>
			super.init( argumentCollection = arguments );
			instance.file = arguments.file;
			ensureFileExists();
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
		
	<cffunction name="write" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />
		<cflock name="file_appender_lock_for_#getName()#" timeout="30">
			<cffile action="append" file="#instance.file#" output="#getLayout().format( arguments.event )#" addnewline="true" />
		</cflock>	
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="ensureFileExists" returntype="string" access="public" output="false">
		<cfif not fileExists( instance.file )>
			<cffile action="write" file="#instance.file#" 
				output="Created Log File #dateFormat( now() )# #timeFormat( now() )#" mode="644" addNewLine="true"  />
		</cfif>
	</cffunction>

</cfcomponent>