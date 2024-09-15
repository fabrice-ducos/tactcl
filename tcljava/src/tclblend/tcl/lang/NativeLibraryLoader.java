package tcl.lang;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

import tcl.manifest.ManifestUtil;

public class NativeLibraryLoader {
    static {
        init();
    }

    public static void init() {
        /* it is needed to print exception messages before throwing them, because jrunscript (a standard JSR223 tool)
	 * doesn't display low level exception messages, making troubleshooting difficult
	 */

	String tclblendDebug = System.getProperty("tclblend.debug");
        String currentDirectory = System.getProperty("user.dir");
	String javaLibraryPath = System.getProperty("java.library.path");
        String tclblendLibraryPath = System.getProperty("tclblend.library.path"); // e.g. "/path/to/libtclblend.so"
        String tclblendLibraryStem = System.getProperty("tclblend.library.stem"); // e.g. "tclblend"

        final boolean debug = convertToBoolean(tclblendDebug);
        String libName = "tclblend";
        String libPath = "native/";
        try {
            // Determine the appropriate native library path
            String os = System.getProperty("os.name").toLowerCase();
            String arch = System.getProperty("os.arch").toLowerCase();

            if (os.contains("win")) {
                libPath += "windows/" + libName + ".dll";
            } else if (os.contains("nix") || os.contains("nux") || os.contains("mac")) {
                libPath += os.contains("mac") ? "macos/lib" + libName + ".dylib" : "linux/lib" + libName + ".so";
            } else {
                System.err.println("Unsupported OS: " + os);
                throw new UnsupportedOperationException("Unsupported OS: " + os);
            }

            // Load the library
            InputStream in = NativeLibraryLoader.class.getResourceAsStream("/" + libPath);
            if (in == null) {
                System.err.println("Native library not found: " + libPath);
                throw new RuntimeException("Native library not found: " + libPath + " (current directory: " + currentDirectory + ")");
            }

            Path tempFile = Files.createTempFile(libName, getExtension(libPath));
            try (OutputStream out = new FileOutputStream(tempFile.toFile())) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

            if (debug) {
		        System.err.println("[DEBUG] tclblend.debug: " + tclblendDebug);
                System.err.println("[DEBUG] tempFile: " + tempFile.toAbsolutePath().toString());
		        System.err.println("[DEBUG] java.library.path: " + javaLibraryPath);
                System.err.println("[DEBUG] tclblend.library.path: " + tclblendLibraryPath);
                System.err.println("[DEBUG] tclblend.library.stem: " + tclblendLibraryStem + " (e.g. \"tclblend\")");
	        }

            if (tclblendLibraryPath != null && ! tclblendLibraryPath.isEmpty()) {
                System.load(tclblendLibraryPath);
            }
            else if (tclblendLibraryStem != null && ! tclblendLibraryStem.isEmpty()) {
                System.loadLibrary(tclblendLibraryStem);
            }
            else {
                System.load(tempFile.toAbsolutePath().toString());
            }

            // Clean up
            tempFile.toFile().deleteOnExit();

        } catch (Exception e) {
            System.err.println("Failed to load native library " + libPath + ": " + e);
            throw new RuntimeException("Failed to load native library " + libPath + ": " + e);
        }
    }

    private static String getExtension(String path) {
        int lastDot = path.lastIndexOf('.');
        return (lastDot == -1) ? "" : path.substring(lastDot);
    }

    private static boolean convertToBoolean(final String property, boolean defaultValue) {
        if (property == null) return defaultValue;

        String lowerCase = property.toLowerCase();
        
        if ("true".equals(lowerCase)) {
            return true;
        }
        else if ("yes".equals(lowerCase)) {
            return true;
        }
        else if ("y".equals(lowerCase)) {
            return true;
        }
        else if ("1".equals(lowerCase)) {
            return true;
        }
        else { 
            return false;
        }
    }

    private static boolean convertToBoolean(final String property) {
        return convertToBoolean(property, false);
    }
}
