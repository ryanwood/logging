<cfcomponent name="RepositoryTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			repo = createObject( "component", "logging.Repository" ).init();
		</cfscript>
	</cffunction>

	<cffunction name="testRepoExists" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isInstanceOf( repo, 'logging.Repository' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testRootLoggerIsCreatedOnInit" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue( isInstanceOf( repo.getLogger( 'root' ), 'logging.RootLogger' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testDefaultLogLevels" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals( 'debug,info,warn,error,fatal', repo.getLogger( 'root' ).getLevels() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testCustomLogLevels" returntype="void" access="public" output="false">
		<cfscript>
			var levels = 'good,bad,ugly';
			repo = createObject( "component", "logging.Repository" ).init( levels );
			assertEquals( levels, repo.getLogger( 'root' ).getLevels() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testAddLogger" returntype="void" access="public" output="false">
		<cfscript>
			repo.getLogger( 'A' );
			assertTrue( isInstanceOf( repo.getLogger( 'A' ), 'logging.Logger' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testParent" returntype="void" access="public" output="false">
		<cfscript>
			var loggers = "A A::B A::B::C::D A::B::C::E A::B::C::F";
			var logger = '';
			
			for( i = 1; i lte listLen( loggers, " " ); i = i + 1 ) {
				repo.getLogger( listGetAt( loggers, i, " " ) );
			}

			assertSame( repo.getLogger( 'root' ), repo.getParent( 'A' ) );
			assertSame( repo.getLogger( 'A' ), repo.getParent( 'A::B' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.getParent( 'A::B::C' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.getParent( 'A::B::C::D' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.getParent( 'A::B::C::E' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.getParent( 'A::B::C::F' ) );
			
			repo.getLogger( 'A::B::C' );
			assertSame( repo.getLogger( 'A::B' ), repo.getParent( 'A::B::C' ) );
			assertSame( repo.getLogger( 'A::B::C' ), repo.getParent( 'A::B::C::D' ) );
			assertSame( repo.getLogger( 'A::B::C' ), repo.getParent( 'A::B::C::E' ) );
			assertSame( repo.getLogger( 'A::B::C' ), repo.getParent( 'A::B::C::F' ) );
			
			repo.getLogger( 'A::B::C::E::G' );
			assertSame( repo.getLogger( 'A::B::C::E' ), repo.getParent( 'A::B::C::E::G' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testChildren" returntype="void" access="public" output="false">
		<cfscript>
			var a = arrayNew(1);	// An array of loggers 4 levels deep		
			var t = arrayNew(1);  // a temp reuseable array 
			var keys = "D E F";
			var key = '';
			var logger = '';
			
			repo.getLogger( 'A' );
			assertEquals( a, repo.getChildren( 'A' ) );
			
			t[1] = repo.getLogger( 'A::B' );
						
			for( i = 1; i lte listLen( keys, " " ); i = i + 1 ) {
				arrayAppend( a, repo.getLogger( "A::B::C::#listGetAt( keys, i, " " )#" ) );
			}
					
			assertEquals( t, repo.getChildren( 'A' ) );
			assertEquals( a, repo.getChildren( 'A::B' ) );
			assertEquals( a, repo.getChildren( 'A::B::C' ) );

			t[1] = repo.getLogger( 'A::B::C' );
			assertEquals( t, repo.getChildren( 'A::B' ) );
			assertEquals( a, repo.getChildren( 'A::B::C' ) );
			
			t[1] = repo.getLogger( 'A::B::C::E::G' );
			assertEquals( a, repo.getChildren( 'A::B::C' ) );
			assertEquals( t, repo.getChildren( 'A::B::C::E' ) );
		</cfscript>
	</cffunction>

</cfcomponent>