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
			assertTrue( repo.hasLogger( 'root' ) );
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
			repo.addLogger( 'A' );
			assertTrue( isInstanceOf( repo.getLogger( 'A' ), 'logging.Logger' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testHasLogger" returntype="void" access="public" output="false">
		<cfscript>
			assertFalse( repo.hasLogger( 'unknown' ) );
			repo.addLogger( 'unknown' );
			assertTrue( repo.hasLogger( 'unknown' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testParent" returntype="void" access="public" output="false">
		<cfscript>
			var loggers = "A A::B A::B::C::D A::B::C::E A::B::C::F";
			var logger = '';
			
			for( i = 1; i lte listLen( loggers, " " ); i = i + 1 ) {
				repo.addLogger( listGetAt( loggers, i, " " ) );
			}

			assertSame( repo.getLogger( 'root' ), repo.parent( 'A' ) );
			assertSame( repo.getLogger( 'A' ), repo.parent( 'A::B' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.parent( 'A::B::C' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.parent( 'A::B::C::D' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.parent( 'A::B::C::E' ) );
			assertSame( repo.getLogger( 'A::B' ), repo.parent( 'A::B::C::F' ) );
			
			repo.addLogger( 'A::B::C' );
			assertSame( repo.getLogger( 'A::B' ), repo.parent( 'A::B::C' ) );
			assertSame( repo.getLogger( 'A::B::C' ), repo.parent( 'A::B::C::D' ) );
			assertSame( repo.getLogger( 'A::B::C' ), repo.parent( 'A::B::C::E' ) );
			assertSame( repo.getLogger( 'A::B::C' ), repo.parent( 'A::B::C::F' ) );
			
			repo.addLogger( 'A::B::C::E::G' );
			assertSame( repo.getLogger( 'A::B::C::E' ), repo.parent( 'A::B::C::E::G' ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="testChildren" returntype="void" access="public" output="false">
		<cfscript>
			var loggers = arrayNew(1);
			var keys = "D E F";
			var key = '';
			var logger = '';
			var a = '';
			
			repo.addLogger( 'A' );
			assertEquals( arrayNew(1), repo.children( 'A' ) );
			
			repo.addLogger( 'A::B' );
						
			for( i = 1; i lte listLen( keys, " " ); i = i + 1 ) {
				arrayAppend( loggers, repo.addLogger( "A::B::C::#listGetAt( keys, i, " " )#" ) );
			}
			a = [ repo.getLogger( 'A::B' ) ];
			assertEquals( a, repo.children( 'A' ) );

			/*
			
			def test_children
	      ::Logging::Logger.new('A')

	      assert_equal [], @repo.children('A')

	      ::Logging::Logger.new('A::B')
	      a = %w(D E F).map {|name| ::Logging::Logger.new('A::B::C::'+name)}.sort

	      assert_equal [@repo['A::B']], @repo.children('A')
	      assert_equal a, @repo.children('A::B')
	      assert_equal a, @repo.children('A::B::C')

	      ::Logging::Logger.new('A::B::C')

	      assert_equal [@repo['A::B::C']], @repo.children('A::B')
	      assert_equal a, @repo.children('A::B::C')

	      ::Logging::Logger.new('A::B::C::E::G')

	      assert_equal a, @repo.children('A::B::C')
	      assert_equal [@repo['A::B::C::E::G']], @repo.children('A::B::C::E')
	    end
			
			*/
			
		</cfscript>
	</cffunction>

</cfcomponent>