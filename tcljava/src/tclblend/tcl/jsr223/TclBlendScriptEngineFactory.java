/*
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package tcl.jsr223;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineFactory;

import tcl.manifest.ManifestUtil;

/**
 * TclBlendScriptEngineFactory is required for compliance with the JSR223
 * (script engine discovery mechanism in Java 6+)
 *
 * @author Fabrice Ducos
 */
public class TclBlendScriptEngineFactory implements ScriptEngineFactory
{
    TclBlendScriptEngineFactory(final Options options) {
	this.statementSeparator = (options.statementSeparator != null) ? options.statementSeparator : "";
	this.methodCallSyntax = (options.methodCallSyntax != null) ? options.methodCallSyntax : "TclOO";

	if (! ("".equals(this.statementSeparator) || ";".equals(this.statementSeparator))) {
	    throw new IllegalArgumentException(ILLEGAL_STATEMENT_SEPARATOR + ": \"" + this.statementSeparator + "\"");
	}

	if (! ("TclOO".equals(this.methodCallSyntax))) {
	    throw new UnsupportedOperationException(UNSUPPORTED_METHOD_CALL_SYNTAX + ": " + methodCallSyntax);
	}
    }

    TclBlendScriptEngineFactory() {
	this.statementSeparator = "";
	this.methodCallSyntax = "TclOO";
    }
    
    @Override
    public String getEngineName() {
	return "TclBlend Engine";
    }

    @Override
    public String getEngineVersion() {
	return ManifestUtil.getAttributeValue("TclBlend-EngineVersion");
    }

    @Override
    public List<String> getExtensions() {
	return Collections.unmodifiableList(Arrays.asList("tcl", "jtcl", "jacl"));
    }

    @Override
    public List<String> getMimeTypes() {
	return Collections.unmodifiableList(Arrays.asList("application/x-tcl", "text/x-tcl"));
    }

    @Override
    public List<String> getNames() {
	List<String> names = Arrays.asList("tclblend");
	return Collections.unmodifiableList(names);
    }

    @Override
    public String getLanguageName() {
	return "Tcl";
    }

    @Override
    public String getLanguageVersion() {
	return ManifestUtil.getAttributeValue("TclBlend-LanguageVersion");
    }

    @Override
    public Object getParameter(String key) {
	switch (key) {
	case ScriptEngine.ENGINE: return getEngineName();
	case ScriptEngine.ENGINE_VERSION: return getEngineVersion();
	case ScriptEngine.NAME: return getEngineName();
	case ScriptEngine.LANGUAGE: return getLanguageName();
	case ScriptEngine.LANGUAGE_VERSION: return getLanguageVersion();
	case "THREADING": return "MULTITHREADED";
	default: return null;
	}
    }

    private String getTclOOMethodCallSyntax(String obj, String m, String[] args) {
	// TclOO syntax
	
	String ret = obj;
	ret += " " + m + " ";
	for (int i = 0; i < args.length; i++) {
	    ret += args[i];
	    if (i < args.length - 1) {
		ret += " ";
	    }
	}
	ret += statementSeparator;
	return ret;
    }
    
    @Override
    public String getMethodCallSyntax(String obj, String m, String[] args) {
	if ("TclOO".equals(methodCallSyntax)) {
	    return getTclOOMethodCallSyntax(obj, m, args);
	}
	else {
	    throw new UnsupportedOperationException(UNSUPPORTED_METHOD_CALL_SYNTAX + ": " + methodCallSyntax);
	}
    }

    @Override
    public String getOutputStatement(String toDisplay) {
	return "puts {" + toDisplay + "}";
    }

    @Override
    public String getProgram(String[] statements) {
	String retval = "";
	int len = statements.length;
	for (int i = 0; i < len; i++) {
	    retval += statements[i] + "\n";
	}
	return retval;
    }

    @Override
    public ScriptEngine getScriptEngine() {
	return new TclBlendScriptEngine(this);
    }

    public final class Options {
	// for options, public fields are handy (options will be passed to the factory constructor
	// and copied, one cannot do much more with them)
	public String statementSeparator = "";
	public String methodCallSyntax = "TclOO";
    }

    private final String statementSeparator; // can be "" or ";"
    private final String methodCallSyntax;

    private static final String UNSUPPORTED_METHOD_CALL_SYNTAX = "unknown or not supported value for methodCallSyntax";
    private static final String ILLEGAL_STATEMENT_SEPARATOR = "illegal statement separator";
}
