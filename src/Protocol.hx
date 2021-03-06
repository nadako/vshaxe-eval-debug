import vscode.debugProtocol.DebugProtocol.Thread;

abstract RequestMethod<TParams, TResult>(String) to String {
	public inline function new(method)
		this = method;
}

abstract NotificationMethod<TParams>(String) to String {
	public inline function new(method)
		this = method;
}

typedef ScopeArgs = {
	var frameId:Int;
}

typedef ScopeVarsArgs = {
	var id:Int;
}

typedef GetStructureArgs = {
	var expr:String;
}

typedef SetVariableArgs = {
	var id:Int;
	var name:String;
	var value:String;
}

typedef EvaluateArgs = {
	var frameId:Int;
	var expr:String;
}

@:publicFields
class Protocol {
	static inline final Pause = new RequestMethod<{?threadId:Int}, Void>("pause");
	static inline final Continue = new RequestMethod<{?threadId:Int}, Void>("continue");
	static inline final StepIn = new RequestMethod<{?threadId:Int}, Void>("stepIn");
	static inline final Next = new RequestMethod<{?threadId:Int}, Void>("next");
	static inline final StepOut = new RequestMethod<{?threadId:Int}, Void>("stepOut");
	static inline final GetThreads = new RequestMethod<{}, Array<Thread>>("getThreads");
	static inline final StackTrace = new RequestMethod<{?threadId:Int}, Array<StackFrameInfo>>("stackTrace");
	static inline final SetBreakpoints = new RequestMethod<SetBreakpointsParams, Array<{id:Int}>>("setBreakpoints");
	static inline final SetFunctionBreakpoints = new RequestMethod<SetFunctionBreakpointsParams, Array<{id:Int}>>("setFunctionBreakpoints");
	static inline final SetBreakpoint = new RequestMethod<SetBreakpointParams, {id:Int}>("setBreakpoint");
	static inline final RemoveBreakpoint = new RequestMethod<{id:Int}, Void>("removeBreakpoint");
	static inline final GetScopes = new RequestMethod<ScopeArgs, Array<ScopeInfo>>("getScopes");
	static inline final GetVariables = new RequestMethod<ScopeVarsArgs, Array<VarInfo>>("getVariables");
	static inline final SetVariable = new RequestMethod<SetVariableArgs, VarInfo>("setVariable");
	static inline final BreakpointStop = new NotificationMethod<{threadId:Int}>("breakpointStop");
	static inline final ExceptionStop = new NotificationMethod<{threadId:Int, text:String}>("exceptionStop");
	static inline final ThreadEvent = new NotificationMethod<{threadId:Int, reason:String}>("threadEvent");
	static inline final Evaluate = new RequestMethod<EvaluateArgs, VarInfo>("evaluate");
	static inline final SetExceptionOptions = new RequestMethod<Array<String>, Void>("setExceptionOptions");
	static inline final GetCompletion = new RequestMethod<GetCompletionParams, Array<CompletionItem>>("getCompletion");
}

typedef GetCompletionParams = {
	var text:String;
	var column:Int;
}

typedef CompletionItem = {
	var label:String;
	var type:String;
	var ?start:Int;
}

typedef SetBreakpointsParams = {
	var file:String;
	var breakpoints:Array<{line:Int, ?column:Int}>;
}

typedef SetFunctionBreakpointsParams = Array<{
	var name:String;
}>;

typedef SetBreakpointParams = {
	var file:String;
	var line:Int;
	var ?column:Int;
}

typedef StackFrameInfo = {
	var id:Int;
	var name:String;
	var source:Null<String>;
	var line:Int;
	var column:Int;
	var endLine:Int;
	var endColumn:Int;
	var artificial:Bool;
}

/** Info about a scope **/
typedef ScopeInfo = {
	/** Scope identifier to use for the `vars` request. **/
	var id:Int;

	/** Name of the scope (e.g. Locals, Captures, etc) **/
	var name:String;

	/** Position information about scope boundaries, if present **/
	var ?pos:{
		source:String,
		line:Int,
		column:Int,
		endLine:Int,
		endColumn:Int
	};
}

/** Info about a scope variable or its subvariable (a field, array element or something) as returned by Haxe eval debugger **/
typedef VarInfo = {
	/** A unique identifier for this variable. **/
	var id:Int;

	/** Variable/field name, for array elements or enum ctor arguments looks like `[0]` **/
	var name:String;

	/** Value type **/
	var type:String;

	/** Current value to display (structured child values are rendered with `...`) **/
	var value:String;

	/** The number of children the value has. **/
	var numChildren:Int;

	var ?generated:Bool;
	var ?line:Int;
	var ?column:Int;
}

typedef AccessExpr = String;
