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
	
	<cffunction name="addLogger" returntype="logging.Logger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfscript>
			var logger = createObject( "component", "logging.Logger" ).init( arguments.name );
			var parent = parent( arguments.name );
			logger.setParent( parent );
			logger.setLevels( parent.getLevels() );
			logger.setLevel( parent.getLevel() );
			instance.repo[ arguments.name ] = logger;
			return logger;
		</cfscript>
	</cffunction>
	
	<cffunction name="getLogger" returntype="logging.Logger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn instance.repo[ arguments.name ] />
	</cffunction>

	<cffunction name="hasLogger" returntype="boolean" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn structKeyExists( instance.repo, arguments.name ) />
	</cffunction>
	
	<cffunction name="parent" returntype="logging.Logger" access="public" output="false">
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
		<cfreturn arrayNew(1) />		
		/*
    def children( key )
      key = to_key(key)
      depth = key.split(PATH_DELIMITER).length
      rgxp = Regexp.new "^#{key}#{PATH_DELIMITER}"

      a = @h.keys.map do |k|
            if k =~ rgxp
              l = @h[k]
              d = l.parent.name.split(PATH_DELIMITER).length
              if d <= depth then l else nil end
            end
          end
      a.compact.sort
    end
		
		*/
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>