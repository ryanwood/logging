<cfcomponent displayname="Logger" output="false">
	<cfscript>
		instance = structNew();
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			setName( arguments.name );
			setAppenders( arrayNew(1) );
			// This should be inherited from the parent logger
			setLevel( 'all' );
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<cffunction name="onMissingMethod" output="false" access="public">
    <cfargument name="missingMethodName" type="string" />
    <cfargument name="missingMethodArguments" type="struct" />
		<cfset var method = arguments.missingMethodName />
		<cfset var args = parseUnnamedArgs( arguments.missingMethodArguments )  />
		
		<cfif reFindNoCase( "^(#getPipedLevels()#)$", method )>
			<cfif structKeyExists( args, 'message' )>
				<cfset logEvent( createLogEvent( method, args.message, args.error ) ) />	
			</cfif>
		<cfelseif reFindNoCase( "^is(#getPipedLevels()#)$", method )>
			<cfset method = mid( method, 3, len( method )) />
			<cfreturn shouldLog( method ) />
		<cfelse>
			<cfthrow type="logging.MethodNotFound" message="The method #method# was not found in component #getCurrentTemplatePath()#." />
		</cfif>		
	</cffunction>

	<!--- Helpers --->
	<!--- 
	<cffunction name="getElapsedTime" returntype="numeric" output="false" access="public">
		<cfargument name="tickCount" type="numeric" required="true"/>
		<cfreturn (arguments.tickCount - getStartTick())/1000 />
	</cffunction>

	<cffunction name="streamline" access="public" returntype="string" output="false"
		hint="Removes all line breaks, multiple whitespace occurence, and tabs">
		<cfargument name="text" type="string" required="Yes" />
		<cfset var out = rereplacenocase(arguments.text, "\n", " ", "all") />
		<cfset out = rereplacenocase(out, "\t", " ", "all") />
		<cfset out = rereplacenocase(out, "\s{2,}", " ", "all") />
		<cfreturn out />
	</cffunction> 
	--->

	<!--- Accessors --->

	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn instance.name />
	</cffunction>

	<cffunction name="getAppenders" returntype="Array" output="false" hint="I get the appender collection" access="public">
		<cfreturn instance.appenders />
	</cffunction>

	<cffunction name="setAppenders" returntype="void" output="false" hint="I set the appender collection" access="public">
		<cfargument name="appenders" type="any" required="true" hint="Can be an array of appenders or one appender" />
		<cfset var container = arrayNew(1) />
		<cfif not isArray( arguments.appenders ) and isInstanceOf( "logging.Appender", arguments.appenders )>
			<cfset arrayAppend( container, arguments.appenders) />
			<cfset instance.appenders = container />
		</cfif>
		<cfset instance.appenders = arguments.appenders />
	</cffunction>
	
	<cffunction name="addAppender" returntype="void" output="false" access="public">
		<cfargument name="appender" type="logging.Appender" required="true"/>
		<cfset arrayAppend( instance.appenders, arguments.appender ) />
	</cffunction>

	<cffunction name="removeAppender" returntype="void" output="false" access="public">
		<cfargument name="name" type="string" required="true" hint="an appender name" />
		<cfset var i = 0 />
		<cfset var tmp = arrayNew( 1 ) />
		
		<cfloop index="i" from="1" to="#arrayLen( instance.appenders )#">
			<cfif instance.appenders[i].getName() neq arguments.name>
				<cfset arrayAppend( tmp, instance.appenders[i] ) />
			</cfif>
		</cfloop>
		
		<cfset instance.appenders = tmp />
	</cffunction>
	
	<cffunction name="getLevels" returntype="string" output="false" access="public">
		<cfreturn instance.levels />
	</cffunction>
	
	<cffunction name="getFormattedLevelList" returntype="string" output="false" access="public">
		<cfreturn listChangeDelims( getLevels(), ', ') />
	</cffunction>
	
	<cffunction name="getLevelMap" returntype="struct" output="false" access="public">
		<cfreturn instance.levelMap />
	</cffunction>

	<cffunction name="getLevel" returntype="numeric" output="false" hint="I get the amount of information to be logged" access="public">
		<cfif not structKeyExists( instance, 'level' )>
			<cfthrow type="logging.LevelNotDefined" message="You must set the level of this logger using setLevel() prior to using it. #getValidLogLevelMessage()#" />
		</cfif>
		<cfreturn instance.level />
	</cffunction>

	<cffunction name="getLevelName" returntype="numeric" output="false" hint="I get the amount of information to be logged" access="public">
		<cfreturn listGetAt( instance.levels, instance.level ) />
	</cffunction>

	<cffunction name="setLevel" returntype="void" output="false" hint="I set the amount of information to be logged" access="public">
		<cfargument name="level" type="any" required="true"/>
		<cfif isNumeric( arguments.level ) and arguments.level gt 0 and arguments.level lte ( listLen( getLevels() ) + 1 )>
			<cfset instance.level = arguments.level />
		<cfelseif isSimpleValue( arguments.level )>
			<cfif arguments.level is 'all'>
				<cfset instance.level = 1 />
			<cfelseif arguments.level is 'off'>
				<cfset instance.level = listLen( getLevels() ) + 1 />
			<cfelseif structKeyExists( instance.levelMap, arguments.level )>
				<cfset instance.level = instance.levelMap[arguments.level]/>
			<cfelse>
				<cfthrow type="logging.InvalidLogLevel" message="Unable to set invalid log level: #arguments.level#. #getValidLogLevelMessage()#" />
			</cfif>
		<cfelse>
			<cfthrow type="logging.InvalidLogLevel" message="Unable to set invalid log level. #getValidLogLevelMessage()#" />
		</cfif>
	</cffunction>	
		
	<cffunction name="getMaxLevelLength" output="false" access="public">
		<cfreturn instance.maxLevelLength />
	</cffunction>
	
	<cffunction name="getAddtive" returntype="boolean" output="false" access="public">
		<cfreturn instance.additive />
	</cffunction>

	<cffunction name="setAdditive" returntype="void" output="false" access="public">
		<cfargument name="value" type="boolean" required="true"/>
		<cfset instance.additive = arguments.value />
	</cffunction>
	
	<cffunction name="getParent" returntype="logging.Logger" output="false" access="public">
		<cfreturn instance.parent />
	</cffunction>
	<!--- 
	<cffunction name="getStartTick" returntype="numeric" output="false" access="public">
		<cfif isDefined("instance.startTick")>
			<cfreturn instance.startTick />
		</cfif>
		<cfreturn 0 />
	</cffunction>

	<cffunction name="setStartTick" returntype="void" output="false" access="public">
		<cfargument name="tickCount" type="numeric" required="true"/>
		<cfset instance.startTick = arguments.tickCount />
	</cffunction>
	 --->
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<cffunction name="configure" returntype="void" access="package" output="false">
		<cfargument name="levels" required="true" />
		<cfset setLevels( arguments.levels ) />
	</cffunction>

	<cffunction name="setParent" returntype="void" output="false" access="package">
		<cfargument name="value" type="logging.Logger" required="true"/>
		<cfset instance.parent = arguments.value />
	</cffunction>
	
	<cffunction name="setLevels" output="false" access="package">
		<cfargument name="levels" type="string" required="true" hint="A string such as 'debug,info,warn'"/>
		<cfset var level = 0 />
		<cfset instance.levels = arguments.levels />
		<cfset instance.levelMap = structNew() />
		<cfset instance.maxLevelLength = 0 />
		<cfloop from="1" to="#listLen( arguments.levels )#" index="i">
			<cfset level = listGetAt( arguments.levels, i ) />
			<cfset instance.levelMap[ level ] = i />
			<cfif len(level) gt instance.maxLevelLength>
				<cfset instance.maxLevelLength = len(level) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="logEvent" returntype="void"  access="package" output="false">
		<cfargument name="event" type="logging.LogEvent" required="true" />
	
		<cfif shouldLog( arguments.event.getLevel() )>
			<cfloop index="i" from="1" to="#arrayLen( instance.appenders )#">
				<cfset instance.appenders[i].write( arguments.event ) />
			</cfloop>
		</cfif>
		
		<!--- <cfif getAdditive()>
					<cfset getParent().logEvent( arguments.event ) />			
				</cfif> --->
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<cffunction name="setName" access="private" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset instance.name = arguments.name />
	</cffunction>

	<cffunction name="getPipedLevels" output="false" access="private">
		<cfif not structKeyExists( instance, 'pipedLevels' )>
			<cfset instance.pipedLevels = listChangeDelims(getLevels(), '|') />
		</cfif>
		<cfreturn instance.pipedLevels />
	</cffunction>
	
	<cffunction name="getValidLogLevelMessage" output="false" access="private">
		<cfreturn "Valid values for this logger are #getFormattedLevelList()#." />
	</cffunction>	

	<cffunction name="createLogEvent"  access="private" output="false">
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="error" required="false" hint="a cfcatch instance" />	
		
		<cfreturn createobject( 'component', 'logging.LogEvent' ).init( this, level, message, error ) />
	</cffunction>

	<cffunction name="shouldLog" returntype="boolean" access="private" output="false"
		hint="I determine if a log message should be written based on the log level">
		<cfargument name="level" type="string" required="true" hint="the log level to filter on"/>
		<cfreturn ( structFind( getLevelMap(), level ) gte getLevel() )>
	</cffunction>
	
	<cffunction name="parseUnnamedArgs" returntype="struct" access="private" output="false">
		<cfargument name="args" required="true" />
		<cfset var len = arrayLen( arguments.args ) />
		<cfset var st = structNew() />
		<cfif len>
			<cfset st.message = arguments.args[1] />
			<cfset st.error = '' />
		</cfif>
		<cfif len gte 2>
			<cfset st.error = arguments.args[2] />
		</cfif>
		<cfreturn st />
	</cffunction>
	
</cfcomponent>