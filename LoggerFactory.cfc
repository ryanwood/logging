<cfcomponent displayname="LoggerFactory" output="false">
	<cfscript>
		instance = structNew();
	</cfscript>
	
	<cffunction name="init" access="public" output="false" hint="Singleton Logger Factory">
		<cfargument name="levels" type="string" required="false" />
		<cfscript>
			setRepository( createObject( "component", "logging.Repository" ).init( argumentCollection = arguments ) );
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->		
	
	<cffunction name="getLogger" returntype="logging.Logger" access="public" output="false">
		<cfargument name="name" type="string" required="true"/>
		<cfreturn getRepository().getLogger( arguments.name )  />
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getRepository" access="private" output="false">
		<cfreturn instance.repository />
	</cffunction>
	
	<cffunction name="setRepository" access="private" output="false">
		<cfargument name="repository" type="logging.Repository" required="true" />
		<cfset instance.repository = arguments.repository />
	</cffunction>

</cfcomponent>