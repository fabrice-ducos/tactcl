public class CharTest3 {
    public static void main(String[] argv) {
	char c;
	int i;
	for (i = 0; i < 160 ; i++) {
	    c = (char) i;
	    test(c);
	}
    }

    public static void test(char c) {
	if (Character.isLetterOrDigit(c)) {
	System.out.println("testing charcter '" + c + "'");
	}

	System.out.println("unicode value is " + ((int) c) );	

	System.out.println("isDigit() is " +
			   Character.isDigit(c));   
	System.out.println("isLetter() is " +
			   Character.isLetter(c));
	System.out.println("isLetterOrDigit() is " +
			   Character.isLetterOrDigit(c));

	System.out.println("isSpaceChar() is " +
			   Character.isSpaceChar(c));
	System.out.println("isWhitespace() is " +
			   Character.isWhitespace(c));

	System.out.println("isJavaIdentifierStart() is " +
			   Character.isJavaIdentifierStart(c));


	System.out.println("isJavaIdentifierPart() is " +
			   Character.isJavaIdentifierPart(c));
	System.out.println("isJavaIdentifierStart() is " +
			   Character.isJavaIdentifierStart(c));
	System.out.println("isIdentifierIgnorable() is " +
			   Character.isIdentifierIgnorable(c));
	System.out.println("isUnicodeIdentifierStart() is " +
			   Character.isUnicodeIdentifierStart(c));
	System.out.println("isUnicodeIdentifierPart() is " +
			   Character.isUnicodeIdentifierPart(c));
	
	System.out.println();
    }


}
