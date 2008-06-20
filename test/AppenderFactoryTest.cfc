<cfcomponent name="AppenderFactoryTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			factory = createObject( "component", "logging.AppenderFactory" ).init();
		</cfscript>
	</cffunction>

	<cffunction name="testFactoryExists" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isObject( factory ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAppender" returntype="void" access="public" output="false">
		<cfscript>
			var appender = factory.getAppender( 'my_file', 'File' );
			assertTrue( isInstanceOf( appender, 'logging.Appender' ) );
		</cfscript>
	</cffunction>

	<cffunction name="testGetAppender" returntype="void" access="public" output="false">
		<cfscript>
			var appender = factory.getAppender( 'my_file', 'File' );
			assertTrue( isInstanceOf( appender, 'logging.Appender' ) );
		</cfscript>
	</cffunction>
	
<!--- 	<cffunction name="testGetAppenderReturnsTheSameAppenderInstance" returntype="void" access="public" output="false">
		<cfscript>
			var appender = factory.getAppender( 'base' );
			var appender2 = factory.getAppender( 'base' );
			assertSame( appender, appender2 );
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
	</cffunction> --->
	

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- 	<cffunction name="getHash" returntype="string" access="private" output="false">
		<cfargument name="obj" required="true" />
		<cfscript>
			var system = createObject( "java", "java.lang.System" );
			return javaCast( "string", system.identityHashCode( arguments.obj ) );
		</cfscript>
	</cffunction> --->
	
</cfcomponent>