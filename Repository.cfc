<cfcomponent displayname="logging.Repository" output="false">
	<cfscript>
		instance = structNew();
		PATH_DELIMITER = '::';
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="levels" type="string" required="false" default="debug,info,warn,error,fatal" />
		<cfset instance.repo = structNew() />
		<!--- Create Root Logger --->
		<cfset instance.repo['root'] = createObject( "component", "logging.RootLogger" ).init( arguments.levels ) />
		<cfreturn this />
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->		
	
	<cffunction name="addLogger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfscript>
			var logger = createObject( "component", "logging.Logger" ).init( arguments.name );
			var parent = parent( arguments.name );
			logger.setParent( parent );
			logger.setLevels( parent.getLevels() );
			logger.setLevel( parent.getLevel() );
			instance.repo[ arguments.name ] = logger;
		</cfscript>
	</cffunction>
	
	<cffunction name="getLogger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn instance.repo[ arguments.name ] />
	</cffunction>

	<cffunction name="hasLogger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn structKeyExists( instance.repo, arguments.name ) />
	</cffunction>
	
	<cffunction name="parent" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfscript>
			var a = listToArray( arguments.name, PATH_DELIMITER );
			var p = getLogger( 'root' );
			var k = '';
			
			arrayDeleteAt( a, arrayLen( a ) );
			while ( arrayLen( a ) gt 0 ) {
				k = arrayToList( a, PATH_DELIMITER );
				if( hasLogger( k ) ) {
					p = getLogger( k );
					break;
				}
				arrayDeleteAt( a, arrayLen( a ) );
			}
			return p;
		</cfscript>
	</cffunction>
	
	<cffunction name="children" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<!--- <cfreturn structKeyExists( instance.repo, arguments.name ) /> --->
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>