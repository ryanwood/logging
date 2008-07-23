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
			var found = refind( '%c([0-9]+)', s, 1, true );
			var pad = len( arguments.event.getLogger().getName() ) + 1;
			
			if( arrayLen(found.pos) gt 1 ) {
				pad = mid( s, found.pos[2], found.len[2] );
				s = rereplace( s, '%c[0-9]+', '%c' );
			}
						
			s = replacenocase( s, '%l', ucase( ljustify( arguments.event.getLevel(), arguments.event.getLogger().getMaxLevelLength() ) ) );
			s = replacenocase( s, '%d', formatNow( arguments.event.getTimestamp() ) );
			s = replacenocase( s, '%m', arguments.event.getMessage() );
			s = replacenocase( s, '%c', lJustify( arguments.event.getLogger().getName(), pad ) );
			return s;
		</cfscript>		
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>