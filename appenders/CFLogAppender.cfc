<cfcomponent displayname="CFLogAppender" extends="logging.Appender" output="false">
	
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
		<!--- Note: No formatter is used in this appender --->	
		<cflog application="true"
				type="#translateLevel( arguments.event.getlevel() )#"
				file="#instance.file#"
				text="#arguments.event.getMessage()#" />
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="translateLevel" returntype="string" access="private" output="false" hint="I translate levels so cflog will understand">
		<cfargument name="level" type="string" required="true"  />
		<!--- CFLog only understands: Information, Warning, Error, Fatal --->
		<cfif refindnocase( "(error|fatal)", arguments.level )>
			<cfreturn arguments.level />
		<cfelseif refindnocase( "warn(ing)?", arguments.level )>
			<cfreturn "warning" />
		<cfelse>
			<cfreturn "information" />
		</cfif>
	</cffunction>	

</cfcomponent>
