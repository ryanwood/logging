<cfscript>
	factory = createObject( "component", "logging.LoggerFactory" ).init();
	l1 = factory.getLogger( 'A' );
	l2 = factory.getLogger( 'A::B::C::D::E' );
	
	dir = getDirectoryFromPath( getCurrentTemplatePath() );
	
	layout = createObject( "component", "logging.layouts.PatternLayout" ).init( '%l %d [%c] %m' );
	
	fileApdrA = createObject( "component", "logging.appenders.FileAppender" ).init( 'logfile', '#dir#log/A.log', layout );
	fileApdrB = createObject( "component", "logging.appenders.FileAppender" ).init( 'logfile2', '#dir#log/AB.log' );
	
	l1.addAppender( fileApdrA );
	l2.addAppender( fileApdrB );
	
	l1.debug( 'This should only be in A file.' );
	l2.info( 'This should be in both files.' );
</cfscript>
Done