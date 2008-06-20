<cfcomponent displayname="LoggerTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			// These are the default, but just to be explicit for the tests
			levels = 'debug,info,warn,error,fatal';
			factory = createObject( "component", "logging.LoggerFactory" ).init( levels );
			logger = factory.getLogger( 'base' );
		</cfscript>
	</cffunction>

	<cffunction name="testLoggerExists" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isObject( logger ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testLogLevels" returntype="void" access="public" output="false">
		<cfscript>
			var level = '';
			var i = 1;
			
			for( i = 1; i lte listLen( levels ); i = i + 1 ) {
				level = listGetAt( levels, i );
				assertTrue( structKeyExists( logger.getLevelMap(), level ), "'#level#' is not a valid level." );
			}
			assertEquals( listLen( levels ), structCount( logger.getLevelMap() ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testIsLevel" returntype="void" access="public" output="false">
		<cfscript>
			logger.setLevel( 'debug' );
			assertTrue( logger.isDebug() );
			assertTrue( logger.isFatal() );
			
			logger.setLevel( 'info' );
			assertFalse( logger.isDebug() );
			assertTrue( logger.isInfo() );
			assertTrue( logger.isWarn() );
			
			logger.setLevel( 'fatal' );
			assertFalse( logger.isDebug() );
			assertFalse( logger.isInfo() );
			assertFalse( logger.isWarn() );
			assertTrue( logger.isFatal() );			
		</cfscript>
	</cffunction>
	
	<cffunction name="testSettingBogusLevelShouldFail" returntype="void" access="public" output="false">
		<cfscript>
			try {
				logger.setLevel( 'foo' );
				fail( "Allowed invalid level to be set." );
			} catch( logging ex ) {
				assertEquals( "logging.InvalidLogLevel", ex.type );
				assertEquals( "Unable to set invalid log level: foo. Valid values for this logger are #logger.getFormattedLevelList()#.", ex.message );
			} 
		</cfscript>
	</cffunction>
	
	<cffunction name="testIsBogusLevelShouldFail" returntype="void" access="public" output="false">
		<cfscript>
			logger.setLevel( 'debug' );
			try {
				logger.isHumble();
				fail( "Allowed invalid level to be tested." );
			} catch( logging ex ) {
				assertEquals( "logging.MethodNotFound", ex.type );
			} 
		</cfscript>
	</cffunction>
	
	<cffunction name="testShouldSetLogLevelFirst" returntype="void" access="public" output="false">
		<cfscript>
 			try {
				logger.isDebug();
				fail( "Allowed invalid level to be tested before level was set." );
			} catch( logging ex ) {
				assertEquals( "logging.LevelNotDefined", ex.type );
			} 
		</cfscript>
	</cffunction>
	
	<cffunction name="testMaxLevelLength" returntype="void" access="public" output="false">
		<cfscript>
 			assertEquals( 5, logger.getMaxLevelLength() );
		</cfscript>
	</cffunction>

	
<!------------------------------------------- PRIVATE ------------------------------------------->
	
</cfcomponent>