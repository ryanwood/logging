<cfcomponent displayname="ExceptionLayout" extends="logging.Layout" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfscript>
			super.init();
			clearBuffer();
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
		
	<cffunction name="format" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />		
		<cfscript>
			var s = "#ucase( ljustify( arguments.event.getLevel(), arguments.event.getLogger().getMaxLevelLength() ) )#";
			s = s & " #formatNow()#";
			s = s & " #arguments.event.getMessage()#";
			if( arguments.event.hasError() ) {
				s = s & parseException(  arguments.event.getError() );
			}
			return s;			
		</cfscript>		
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<cffunction name="parseException" returntype="string" access="private" output="false">
		<cfargument name="exception" required="true" hint="a CFCATCH object" />
			<cfscript>
				var s = '';
				var i = 0;
				var context = arguments.exception.tagcontext;
				
				clearBuffer();				
				writeBlankLine();

				writeLine( "== EXCEPTION INFORMATION ==" );
				writeLine( "TYPE: #arguments.exception.type#" );
				if( len( arguments.exception.message ) ) writeLine( "MESSAGE: #arguments.exception.message#" );
				if( len( arguments.exception.detail ) ) writeLine( "DETAILS: #arguments.exception.detail#" );
				if( len( getBaseTagList() ) ) writeLine( "CALL STACK: #GetBaseTagList()#" );

				if ( arguments.exception.type is "MissingInclude")
					writeLine( "MISSING INCLUDE: #arguments.exception.MissingFileName#" );

				writeLine( "CONTEXT: " );
   			for( i = 1; i le arrayLen(context); i = i + 1 ) {
   				write( indent( 2 ) & 'i:' );
   				if( structKeyExists( context[i], "id" ) ) {
   					write( ' #context[i]["id"]#' );
   				} else {
   					write( ' --' );
   				}
			    writeLine( ' #context[i]["template"]#:#context[i]["line"]#' );
				}

				if(arguments.exception.type is "Database") {
					if( structKeyExists( arguments.exception, 'queryError' ) ) writeLine( "QUERY ERROR: #arguments.exception.queryError#" );
					if( structKeyExists( arguments.exception, 'where' ) ) writeLine( "WHERE: #arguments.exception.where#" );
					if( structKeyExists( arguments.exception, 'nativeerrorcode' ) ) writeLine( "NATIVE ERROR CODE: #arguments.exception.nativeerrorcode#" );
					if( structKeyExists( arguments.exception, 'sqlstate' ) ) writeLine( "SQL STATE: #arguments.exception.sqlstate#" );
					if( structKeyExists( arguments.exception, 'sql' ) ) writeLine( "SQL: #streamline(arguments.exception.sql)#" );
				}

				writeBlankLine();
				writeLine( "== CGI INFORMATION ==" );
				writeLine( "SERVER: #cgi.server_name#" );
				writeLine( "PATH INFO: #cgi.path_info#" );
				if( len( cgi.query_string ) ) writeLine( "QUERY STRING: #cgi.query_string#" );
				writeLine( "USER AGENT: #cgi.http_user_agent#" );
				if( len( cgi.remote_addr ) ) writeLine( "IP: #cgi.remote_addr#" );
				if( len(cgi.http_referer ) ) writeLine( "REFERER: #cgi.http_referer#" );

				if( not structIsEmpty( url ) ) write( parseStruct( url, 'URL PARAMS' ) );
				if( not structIsEmpty( form ) ) write( parseStruct( form, 'FORM PARAMS' ) );

				return instance.buffer;
		</cfscript>
	</cffunction>

	<cffunction name="parseStruct" returnType="string" access="private" output="false">
		<cfargument name="structToParse" type="struct" required="true" />
		<cfargument name="structName" type="string" default="" />
		<cfscript>
			var s = '';
			var i = 0;

			if( not structIsEmpty( arguments.structToParse ) ) {
				s = s & newLine();
				if( len( arguments.structName ) ) { s = s & "== #structName# ==" & newLine(); }
				for( key in arguments.structToParse ) {
					s = s & "#key#: #trim(arguments.structToParse[key])#" & newLine();
				}
			}
			return s;
		</cfscript>
	</cffunction>
	
	<cffunction name="writeLine" returnType="string" access="private" output="false">
		<cfargument name="line" type="string" required="true" />
		<cfset instance.buffer = instance.buffer & indent() & arguments.line & newLine() />
	</cffunction>
	
	<cffunction name="write" returnType="string" access="private" output="false">
		<cfargument name="text" type="string" required="true" />
		<cfset instance.buffer = instance.buffer & arguments.text />
	</cffunction>
	
	<cffunction name="writeBlankLine" returnType="string" access="private" output="false">
		<cfset writeLine( '' ) />
	</cffunction>
	
	<cffunction name="indent" returnType="string" access="private" output="false">
		<cfargument name="count" type="numeric" default="1" />
		<cfreturn repeatString( '  ', arguments.count ) />
	</cffunction>	
	
	<cffunction name="clearBuffer" access="private" returntype="void" output="false">
		<cfset instance.buffer = '' />
	</cffunction>

</cfcomponent>