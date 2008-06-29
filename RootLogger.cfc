<cfcomponent displayname="RootLogger" extends="logging.Logger" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfscript>
			super.init( 'root' );
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->