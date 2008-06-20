<cfcomponent displayname="BasicLayoutTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			layout = createObject( "component", "logging.layouts.BasicLayout" ).init();
			factory = createObject( "component", "logging.LoggerFactory" ).init( 'notification,debug,warn,kill' );
			logger = factory.getLogger( 'base' );
			event = createObject( "component", "logging.LogEvent" ).init( logger, 'debug', 'This is a test message.' );
		</cfscript>
	</cffunction>

	<cffunction name="testFormat" returntype="void" access="public" output="false">
		<cfscript>
			var s = layout.format( event );
			assertTrue( refind( '^DEBUG\s{6}', s ) );
			assertTrue( refind( 'This is a test message.$', s ) );
		</cfscript>
	</cffunction>

</cfcomponent>