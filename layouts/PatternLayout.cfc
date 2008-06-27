<cfcomponent displayname="PatternLayout" extends="logging.Layout" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="pattern" type="string" required="true" />
		<cfscript>
			super.init();
			instance.pattern = arguments.pattern;		
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
		
	<cffunction name="format" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />
		<cfscript>
			var s = instance.pattern;
			s = replacenocase( s, '%l', ucase( ljustify( arguments.event.getLevel(), arguments.event.getLogger().getMaxLevelLength() ) ) );
			s = replacenocase( s, '%d', formatNow() );
			s = replacenocase( s, '%m', arguments.event.getMessage() );
			s = replacenocase( s, '%c', arguments.event.getLogger().getName() );
			return s;
		</cfscript>		
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>