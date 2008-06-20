<cfcomponent name="LogEvent" output="false">
	<cfscript>
		instance = structNew();	
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="logger" type="logging.Logger" required="true"/>
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="error" required="false" />	
		<cfscript>
			instance.logger = arguments.logger;
			instance.level = arguments.level;
			instance.message = arguments.message;
			if( structKeyExists( arguments, 'error' ) and isObject( arguments.error ) ) {
				instance.error = arguments.error;
			}
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<cffunction name="getLogger" output="false" access="public">
		<cfreturn instance.logger />
	</cffunction>
	
	<cffunction name="getLevel" output="false" access="public">
		<cfreturn instance.level />
	</cffunction>
		
	<cffunction name="getMessage" output="false" access="public">
		<cfreturn instance.message />
	</cffunction>
		
	<cffunction name="getError" output="false" access="public">
		<cfreturn instance.error />
	</cffunction>
	
	<cffunction name="hasError" output="false" access="public">
		<cfreturn structKeyExists( instance, 'error' ) />
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>