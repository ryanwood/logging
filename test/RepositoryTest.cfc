<cfcomponent name="RepositoryTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			repo = createObject( "component", "logging.Repository" ).init();
			logger = createObject("component", "logging.Logger").init( 'base' );
			repo.addLogger( 'base', logger );
		</cfscript>
	</cffunction>

	<cffunction name="testRepoExists" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isInstanceOf( repo, 'logging.Repository' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testAddLogger" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isInstanceOf( repo.getLogger( 'base'), 'logging.Logger' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testHasLogger" returntype="void" access="public" output="false">
		<cfscript>
			assertFalse( repo.hasLogger( 'unknown' ) );
			assertTrue( repo.hasLogger( 'base' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testParent" returntype="void" access="public" output="false">
		<cfscript>
			var factory = createObject( "component", "logging.LoggerFactory" ).init();
			var l = factory.getLogger( 'new' );
			debug( l.getLevelMap() );
		</cfscript>
	</cffunction>

</cfcomponent>