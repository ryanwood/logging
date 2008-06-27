<cfcomponent displayname="LogEventTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			logger = createObject( "component", "logging.Logger" ).init( 'base' );
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
			var ex = raiseError();
			assertFalse( event.hasError() );
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'You screwed up!', ex );
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
			var ex = raiseError();
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'You screwed up!', ex );
			assertEquals( ex, event.getError() );
		</cfscript>
	</cffunction>
	
<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="raiseError" access="private" output="false">
		<cfscript>
			var err = 0;
			try { sdfgsdfgsdfg();	} catch ( Any ex ) { 	err = ex;	}
			return err;
		</cfscript>
	</cffunction>
</cfcomponent>