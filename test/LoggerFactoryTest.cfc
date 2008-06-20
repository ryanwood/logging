<cfcomponent name="LoggerFactoryTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			levels = 'debug,info,warn,error,fatal';
			factory = createObject( "component", "logging.LoggerFactory" ).init();
		</cfscript>
	</cffunction>

	<cffunction name="testFactoryExists" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isObject( factory ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetLogger" returntype="void" access="public" output="false">
		<cfscript>
			var logger = factory.getLogger( 'base' );
			assertTrue( isInstanceOf( logger, 'logging.Logger' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetLoggerReturnsTheSameLoggerInstance" returntype="void" access="public" output="false">
		<cfscript>
			var logger = factory.getLogger( 'base' );
			var logger2 = factory.getLogger( 'base' );
			assertSame( logger, logger2 );
		</cfscript>
	</cffunction>
	
	<cffunction name="testDefaultLogLevels" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals( levels, factory.getLevels() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testCustomLogLevels" returntype="void" access="public" output="false">
		<cfscript>
			var levels = 'good,bad,ugly';
			var level = '';
			var i = 1;
			
			factory.setLevels( levels );
			assertEquals( levels, factory.getLevels() );
		</cfscript>
	</cffunction>
	

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- 	<cffunction name="getHash" returntype="string" access="private" output="false">
		<cfargument name="obj" required="true" />
		<cfscript>
			var system = createObject( "java", "java.lang.System" );
			return javaCast( "string", system.identityHashCode( arguments.obj ) );
		</cfscript>
	</cffunction> --->
	
</cfcomponent>