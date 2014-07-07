package designer;

import java.io.InputStream;
import java.io.IOException;

 
public class CubeCreateJob {
    public void execute(String[] args) {
        try {
            ProcessBuilder builder = new ProcessBuilder(args);
            Process process = builder.start();
 /*
            InputStream stream = process.getErrorStream();
            while (true) {
                int c = stream.read();
                if (c == -1) {
                    stream.close();
                    break;
                }
                System.out.print((char)c);
            }
*/
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}
