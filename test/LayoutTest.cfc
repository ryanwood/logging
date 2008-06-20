<cfcomponent name="LayoutTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			layout = createObject( "component", "logging.Layout" ).init();
		</cfscript>
	</cffunction>

	<cffunction name="testFormatMethodIsVirtual" returntype="void" access="public" output="false">
		<cfscript>
			var mf = createObject( "component", "easymock.MockFactory" );
			var event = mf.createNiceMock( 'logging.LogEvent' );
			try {
				layout.format( event );
				fail( "Allowed format() abstract method to be called." );
			} catch( logging ex ) {
				assertEquals( "logging.VirtualMethodError", ex.type );
			} 
		</cfscript>
	</cffunction>
	
	<cffunction name="testFormatNow" returntype="void" access="public" output="false">
		<cfscript>
			var t = now();
			makePublic( layout, "formatNow" );  
			assertEquals( "#dateFormat( t, 'yyyy-mm-dd' )# #timeFormat( t, 'HH:mm:ss.l' )#", layout._formatNow( t ) );
		</cfscript>
	</cffunction>

</cfcomponent>