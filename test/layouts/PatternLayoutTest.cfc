<cfcomponent displayname="PatternLayoutTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			factory = createObject( "component", "logging.LoggerFactory" ).init( 'notification,debug,warn,kill' );
			logger = factory.getLogger( 'base' );
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'This is a test message.' );
		</cfscript>
	</cffunction>

	<cffunction name="testFormat" returntype="void" access="public" output="false">
		<cfscript>
			var layout = createObject( "component", "logging.layouts.PatternLayout" ).init( "%d [%l] %m" );
			var s = layout.format( event );
			assertEquals( 1, refind( '^[0-9:\.\- ]+\[DEBUG\s{7}\] This is a test message.', s ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testLoggerNamePadding" returntype="void" access="public" output="false">
		<cfscript>
			var layout = createObject( "component", "logging.layouts.PatternLayout" ).init( "%c8 %d %m" );
			var s = layout.format( event );
			assertEquals( 1, refind( '^base    [0-9:\.\- ]+ This is a test message.', s ) );
		</cfscript>
	</cffunction>

</cfcomponent>