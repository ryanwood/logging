<cfcomponent displayname="RootLogger" extends="logging.Logger" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="levels" type="string" required="true" hint="A list of levels" />
		<cfscript>
			super.init( 'root' );
			setLevels( arguments.levels );
			setLevel( 1 );
			setAdditive( false );
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->
	
</cfcomponent>