/**
 * 
 */
package test.unittests;

import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * @author xcao
 *
 */
public class AllH5ObjectTests {
    public static Test suite() {
        TestSuite suite = new TestSuite("Test for test.unittests");
        //$JUnit-BEGIN$
        suite.addTestSuite(H5CompoundDSTest.class);
        //$JUnit-END$
        return suite;
    }

    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
    }

}
