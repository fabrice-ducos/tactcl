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
                throw new RuntimeException("Native library not found: " + libPath);
            }

            Path tempFile = Files.createTempFile(libName, getExtension(libPath));
            try (OutputStream out = new FileOutputStream(tempFile.toFile())) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

            System.load(tempFile.toAbsolutePath().toString());

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
}
