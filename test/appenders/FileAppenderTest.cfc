<cfcomponent displayname="FileAppenderTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			mf = createObject( "component", "easymock.MockFactory" );
			logfile = GetTempDirectory() & "test.log";
			clearFile( logfile );			
			layout = mf.createMock( 'logging.Layout' );
			appender = createObject( "component", "logging.appenders.FileAppender" ).init( logfile, layout );
		</cfscript>
	</cffunction>

	<cffunction name="testAppenderExists" returntype="void" access="public" output="false">
		<cfscript>
			assertIsTypeOf( appender, "logging.appenders.FileAppender" );
		</cfscript>
	</cffunction>
	
	<cffunction name="testWrite" returntype="void" access="public" output="false">
		<cfscript>
			var event = mf.createMock( 'logging.LogEvent' );
			var formattedMessage = "DEBUG 12:30PM You had an error";
			debug( logfile );
			mf.expect( layout.format( event ) ).andReturn( formattedMessage );
			
			mf.replay( layout, event );
			appender.write( event );			
			mf.verify( layout, event );
			
			assertEquals( formattedMessage, chomp( readFile( logfile ) ) );			
		</cfscript>
	</cffunction>
	
	<cffunction name="readFile" returntype="string" access="private" output="false">
		<cfargument name="filename" required="true" />
		<cfset var out = '' />
		<cffile action="read" file="#arguments.filename#" variable="out" />
		<cfreturn out />
	</cffunction>

	<cffunction name="clearFile" returntype="void" access="private" output="false">
		<cfargument name="filename" required="true" />
		<cfif fileExists( arguments.filename )>
			<cffile action="delete" file="#arguments.filename#" />
		</cfif>
	</cffunction>
	
	<cffunction name="chomp" returntype="string" access="private" output="false">
		<cfargument name="string" required="true" />
		<cfreturn rereplace( arguments.string, "[\n\r]", "", "all" ) />
	</cffunction>

</cfcomponent>