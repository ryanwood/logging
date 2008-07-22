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
	
	<cffunction name="testIsInvalidLevelShouldFail" returntype="void" access="public" output="false">
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
	
	<cffunction name="testLevelShouldDefaultToAll" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( logger.isDebug() );
			assertEquals( 1, logger.getLevel() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testMaxLevelLength" returntype="void" access="public" output="false">
		<cfscript>
 			assertEquals( 5, logger.getMaxLevelLength() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetLevelAsString" returntype="void" access="public" output="false">
		<cfscript>
			logger.setLevel( 'debug' );
			assertEquals( 1, logger.getLevel() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetLevelAsInteger" returntype="void" access="public" output="false">
		<cfscript>
			logger.setLevel( 2 );
			assertEquals( 2, logger.getLevel() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetLevelAsKeyword" returntype="void" access="public" output="false">
		<cfscript>
			logger.setLevel( 'off' );
			assertEquals( 6, logger.getLevel() );

			logger.setLevel( 'all' );
			assertEquals( 1, logger.getLevel() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetInvalidLevelShouldFail" returntype="void" access="public" output="false">
		<cfscript>
			// set as level string
			logger.setLevel( 'debug' );
			assertEquals( 1, logger.getLevel() );
			// set as integer
			logger.setLevel( 2 );
			assertEquals( 2, logger.getLevel() );
			// set as keyword 'off'
			logger.setLevel( 'off' );
			assertEquals( 6, logger.getLevel() );
			// set as keyword 'all'
			logger.setLevel( 'all' );
			assertEquals( 1, logger.getLevel() );
			
			try { logger.setLevel( -1 ); fail( "Invalid log level allowed." ); } 
			catch( logging ex ) { assertEquals( "logging.InvalidLogLevel", ex.type ); }
			
			try { logger.setLevel( 32 ); fail( "Invalid log level allowed." ); } 
			catch( logging ex ) { assertEquals( "logging.InvalidLogLevel", ex.type ); }
			
			try { logger.setLevel( 'foobar' ); fail( "Invalid log level allowed." ); } 
			catch( logging ex ) { assertEquals( "logging.InvalidLogLevel", ex.type ); }
			
			try { logger.setLevel( structNew() ); fail( "Invalid log level allowed." ); } 
			catch( logging ex ) { assertEquals( "logging.InvalidLogLevel", ex.type ); }			
		</cfscript>
	</cffunction>

	<cffunction name="testEveryLoggerShouldHaveParent" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isObject( logger.getParent() ) );
		</cfscript>
	</cffunction>
	<!---
	<cffunction name="testHasParent" returntype="void" access="public" output="false">
		<cfscript>
			var child = factory.getLogger( 'base::child' );
			assertFalse( logger.hasParent() );
			assertTrue( child.hasParent() );
			assertEquals( logger, child.getParent() );
		</cfscript>
	</cffunction>
	--->
	
<!------------------------------------------- PRIVATE ------------------------------------------->
	
</cfcomponent>