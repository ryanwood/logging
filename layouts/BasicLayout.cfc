<cfcomponent displayname="BasicLayout" extends="logging.Layout" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfscript>
			super.init();			
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
		
	<cffunction name="format" returntype="string" access="public" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />		
		<cfscript>
			var s = "#ucase( ljustify( arguments.event.getLevel(), arguments.event.getLogger().getMaxLevelLength() ) )#";
			s = s & " #formatNow( arguments.event.getTimestamp() )#";
			//if(getStartTick() gt 0) msg = msg & " (#numberformat(getElapsedTime(getTickCount()), "0.000")# secs)";
			s = s & " #arguments.event.getMessage()#";
			//if(not isSimpleValue(arguments.exception)) msg = msg & parseException(arguments.exception);
			return s;
		</cfscript>		
	</cffunction>
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>