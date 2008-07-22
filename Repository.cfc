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
	
	<cffunction name="getLogger" returntype="logging.Logger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfscript>
			var logger = '';
			var parent = '';
			var children = '';
			var i = 1;
			
			if( structKeyExists( instance.repo, arguments.name ) ) {
				return instance.repo[ arguments.name ];			
			} else {
				logger = createObject( "component", "logging.Logger" ).init( arguments.name );
				parent = getParent( arguments.name );
				
				// Set Parent
				logger.setParent( parent );
				logger.setLevels( parent.getLevels() );
				logger.setLevel( parent.getLevel() );
				logger.setAdditive( true );
				
				// Add to repo
				instance.repo[ arguments.name ] = logger;
				
				// Set Children
				children = getChildren( arguments.name );
				for( i=1; i lte arrayLen( children ); i=i+1 ) {
					children[i].setParent( logger );
				}			
									
				return logger;
			}					
		</cfscript>
	</cffunction>
	
	<cffunction name="getParent" returntype="logging.Logger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfscript>
			var a = listToArray( arguments.name, PATH_DELIMITER );
			var p = getLogger( 'root' );
			var k = '';
			
			arrayDeleteAt( a, arrayLen( a ) );
			while ( arrayLen( a ) gt 0 ) {
				k = arrayToList( a, PATH_DELIMITER );
				if( structKeyExists( instance.repo, k ) ) {
					p = getLogger( k );
					break;
				}
				arrayDeleteAt( a, arrayLen( a ) );
			}
			return p;
		</cfscript>
	</cffunction>
	
	<cffunction name="getChildren" returntype="array" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfscript>
			var depth = listLen( arguments.name, PATH_DELIMITER );
			var re = "^#arguments.name##PATH_DELIMITER#";
			var children = arrayNew(1);
			var logger = '';
			var d = 0;
			
			for( key in instance.repo ) {
				if( refindnocase( re, key ) ) {
					
					logger = instance.repo[ key ];
					d = listLen( logger.getParent().getName(), PATH_DELIMITER );
					if( d lte depth ) {
						arrayAppend( children, logger );
					}
				}
			}
			/*
			if(arrayLen(children)){
				dump(key);				
				dump(children[1].getName(), true);
			}
			*/
			return children;
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
		</cfscript>
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<cffunction name="dump" output="true" returntype="void">
		<cfargument name="v" type="any" required="true"/>
		<cfargument name="abort" type="boolean" required="false" default="false" />
		<cfdump var="#arguments.v#"/>
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>
	
</cfcomponent>