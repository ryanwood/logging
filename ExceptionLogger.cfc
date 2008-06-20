<cfcomponent name="ExceptionLogger" output="false" extends="clearcheck.logging.Logger">
	
	<cffunction name="init" access="public" returntype="clearcheck.logging.ExceptionLogger" output="false">
		<cfargument name="logLevel" type="string" required="false" default="error"/>		
		<cfscript>
			super.init(arguments.logLevel);
			return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<cffunction name="debug" returntype="void" output="false" hint="I send debug information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfargument name="exception" required="false" hint="I an exception object" default="0" />
		<cfset writeLog("debug", "DEBUG: #arguments.message#", arguments.exception)/>
	</cffunction>
	
	<cffunction name="info" returntype="void" output="false" hint="I send information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfargument name="exception" required="false" hint="I an exception object" default="0" />
		<cfset writeLog("info", arguments.message, arguments.exception)/>
	</cffunction>

	<cffunction name="warn" returntype="void" output="false" hint="I send warning information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfargument name="exception" required="false" hint="I an exception object" default="0" />
		<cfset writeLog("warn", arguments.message, arguments.exception)/>
	</cffunction>

	<cffunction name="error" returntype="void" output="false" hint="I send warning information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfargument name="exception" required="false" hint="I an exception object" default="0" />
		<cfset writeLog("error", arguments.message, arguments.exception)/>
	</cffunction>
		
	<cffunction name="fatal" returntype="void" output="false" hint="I send fatal error information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfargument name="exception" required="false" hint="I an exception object" default="0" />
		<cfset writeLog("fatal", arguments.message, arguments.exception)/>
	</cffunction>	
	
	<!------------------------------------------- PACKAGE ------------------------------------------->
	
	<!------------------------------------------- PRIVATE ------------------------------------------->
	
	<cffunction name="writeLog" access="private" returntype="void" output="false">
		<cfargument name="level" type="string" required="true" hint="I am the level of the supplied logging information"/>
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfargument name="exception" required="false" hint="I an exception object" default="0" />
		
		<cfthrow type="NotImplementedError" />
	</cffunction>
	
	<cffunction name="parseException" returntype="string" output="false" access="public">
		<cfargument name="exception" required="true" hint="a CFCATCH object" />
			<cfscript>
				var s = '';
				var i = 0;
				var lf = chr(13) & chr(10);
				var context = arguments.exception.tagcontext;

				s = lf;
				s = s & "== EXCEPTION INFORMATION ==#lf#";
				s = s & "TYPE: #arguments.exception.type##lf#";
				if(len(arguments.exception.message)) s = s & "MESSAGE: #arguments.exception.message##lf#";
				if(len(arguments.exception.detail)) s = s & "DETAILS: #arguments.exception.detail##lf#";
				if(len(getBaseTagList())) s = s & "CALL STACK: #GetBaseTagList()##lf#";

				if (arguments.exception.type is "MissingInclude")
					s = s & "MISSING INCLUDE: #arguments.exception.MissingFileName##lf#";

				s = s & "CONTEXT: #lf#";
   			for( i=1; i le arrayLen(context); i=i+1 ) {
   				s = s & ' #i#:';
   				if(structKeyExists(context[i], "id")) {
   					s = s & ' #context[i]["id"]#';
   				} else {
   					s = s & ' --';
   				}
			    s = s & ' #context[i]["template"]#:#context[i]["line"]##lf#';
				}

				if(arguments.exception.type is "Database") {
					if(structKeyExists(arguments.exception, 'queryError')) s = s & "QUERY ERROR: #arguments.exception.queryError##lf#";
					if(structKeyExists(arguments.exception, 'where')) s = s & "WHERE: #arguments.exception.where##lf#";
					if(structKeyExists(arguments.exception, 'nativeerrorcode')) s = s & "NATIVE ERROR CODE: #arguments.exception.nativeerrorcode##lf#";
					if(structKeyExists(arguments.exception, 'sqlstate')) s = s & "SQL STATE: #arguments.exception.sqlstate##lf#";
					if(structKeyExists(arguments.exception, 'sql')) s = s & "SQL: #streamline(arguments.exception.sql)##lf#";
				}

				s = s & lf;
				s = s & "== CGI INFORMATION ==#lf#";
				s = s & "SERVER: #cgi.server_name##lf#";
				s = s & "PATH INFO: #cgi.path_info##lf#";
				if(len(cgi.query_string)) s = s & "QUERY STRING: #cgi.query_string##lf#";
				s = s & "USER AGENT: #cgi.http_user_agent##lf#";
				if(len(cgi.remote_addr)) s = s & "IP: #cgi.remote_addr##lf#";
				if(len(cgi.http_referer)) s = s & "REFERER: #cgi.http_referer##lf#";

				if(not structIsEmpty(url)) s = s & parseStruct(url, 'URL PARAMS');
				if(not structIsEmpty(form)) s = s & parseStruct(form, 'FORM PARAMS');

				return s;
		</cfscript>
	</cffunction>

	<cffunction name="parseStruct" returnType="string" output="false" access="public">
		<cfargument name="structToParse" type="struct" required="true" />
		<cfargument name="structName" type="string" default="" />
		<cfscript>
			var s = '';
			var i = 0;
			var lf = chr(13) & chr(10);

			if(not structIsEmpty(arguments.structToParse)) {
				s = s & lf;
				if(len(arguments.structName)) { s = s & "== #structName# ==#lf#"; }
				for(key in arguments.structToParse) {
					s = s & "#key#: #trim(arguments.structToParse[key])##lf#";
				}
			}
			return s;
		</cfscript>
	</cffunction>
	
</cfcomponent>