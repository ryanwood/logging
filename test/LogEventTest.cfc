<cfcomponent displayname="LogEventTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			logger = createObject( "component", "logging.Logger" ).init();
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'You screwed up!' );
		</cfscript>
	</cffunction>

	<cffunction name="testLogEventExists" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isInstanceOf( event, 'logging.LogEvent' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testHasError" returntype="void" access="public" output="false">
		<cfscript>
			assertFalse( event.hasError() );
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'You screwed up!', structNew() );
			assertTrue( event.hasError() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetLogger" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isInstanceOf( event.getLogger(), 'logging.Logger' ) );
			assertEquals( logger, event.getLogger() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetLevel" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals( 'debug', event.getLevel() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetMessage" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals( 'You screwed up!', event.getMessage() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetError" returntype="void" access="public" output="false">
		<cfscript>
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'You screwed up!', structNew() );
			assertEquals( structNew(), event.getError() );
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>