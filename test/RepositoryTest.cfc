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
			
			
			/*
	    def test_parent
	      %w(A A::B A::B::C::D A::B::C::E A::B::C::F).each do |name|
				
	        ::Logging::Logger.new(name)
	      end

	      assert_same @repo[:root], @repo.parent('A')
	      assert_same @repo['A'], @repo.parent('A::B')
	      assert_same @repo['A::B'], @repo.parent('A::B::C')
	      assert_same @repo['A::B'], @repo.parent('A::B::C::D')
	      assert_same @repo['A::B'], @repo.parent('A::B::C::E')
	      assert_same @repo['A::B'], @repo.parent('A::B::C::F')

	      ::Logging::Logger.new('A::B::C')

	      assert_same @repo['A::B'], @repo.parent('A::B::C')
	      assert_same @repo['A::B::C'], @repo.parent('A::B::C::D')
	      assert_same @repo['A::B::C'], @repo.parent('A::B::C::E')
	      assert_same @repo['A::B::C'], @repo.parent('A::B::C::F')

	      ::Logging::Logger.new('A::B::C::E::G')

	      assert_same @repo['A::B::C::E'], @repo.parent('A::B::C::E::G')
	    end
	*/
		</cfscript>
	</cffunction>

</cfcomponent>