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

/**
 * TclBlendScriptEngineFactory is required for compliance with the JSR223
 * (script engine discovery mechanism in Java 6+)
 *
 * @author Fabrice Ducos
 */
public class TclBlendScriptEngineFactory implements ScriptEngineFactory
{
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

    @Override
    public String getMethodCallSyntax(String obj, String m, String[] p) {
	throw new UnsupportedOperationException("getMethodCallSyntax is not yet implemented");
    }

    @Override
    public String getOutputStatement(String toDisplay) {
	throw new UnsupportedOperationException("getOutputStatement is not yet implemented");
    }

    @Override
    public String getProgram(String[] statements) {
	throw new UnsupportedOperationException("getProgram is not yet implemented");
    }

    @Override
    public ScriptEngine getScriptEngine() {
	return new TclBlendScriptEngine(this);
    }
}
