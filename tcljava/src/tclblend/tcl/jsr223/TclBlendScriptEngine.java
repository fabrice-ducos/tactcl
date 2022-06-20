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

import javax.script.AbstractScriptEngine;
import javax.script.Bindings;
import javax.script.ScriptContext;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptException;
import javax.script.SimpleBindings;

import java.io.BufferedReader;
import java.io.Reader;
import java.io.IOException;

import tcl.lang.*;

/**
 * TclBlendScriptEngine is required for compliance with the JSR223
 * (script engine discovery mechanism in Java 6+)
 *
 * @author Fabrice Ducos
 */
public class TclBlendScriptEngine extends AbstractScriptEngine
{
    
    public TclBlendScriptEngine(ScriptEngineFactory factory) {
	this.factory = factory;
	this.interp = new Interp();
    }

    @Override
    public Object eval(String script, ScriptContext context) throws ScriptException {
	//throw new UnsupportedOperationException("eval(String, ScriptContext) is not yet implemented");

	// the TclBlend API provides: evalFile(String filename), evalResource(String resource), eval(String script), eval(String script, int flags)
	// flags can be: 0 or TCL.EVAL_GLOBAL
	
	try {
	    interp.eval(script);
	}
	catch (TclException ex) {
	    throw new ScriptException(ex);
	}

	TclObject result = interp.getResult();

	// for the moment, one will just return the string representation of the TclObject
	return result.toString();
	
    }

    @Override
    public Object eval(Reader reader, ScriptContext context) throws ScriptException {
	BufferedReader br = new BufferedReader(reader);

	StringBuilder sb = new StringBuilder();
	String line = null;
	try {
	    while ((line = br.readLine()) != null) {
		sb.append(line);
	    }
	}
	catch (IOException ex) {
	    throw new ScriptException(ex);
	}

	return eval(sb.toString(), context);
    }

    @Override
    public Bindings createBindings() {
	return new SimpleBindings();
    }

    @Override
    public ScriptEngineFactory getFactory() {
	return factory;
    }

    private final ScriptEngineFactory factory;
    private final Interp interp;
}
