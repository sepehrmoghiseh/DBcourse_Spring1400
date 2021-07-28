import redis.clients.jedis.Jedis;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) throws IOException {
        Jedis jedis = new Jedis("localhost");
        BufferedReader csvReader = new BufferedReader(new FileReader("src\\NYSE_20210301.csv"));
        String row;
        while ((row = csvReader.readLine()) != null) {
            String[] data = row.split(",");
            jedis.set(data[0], data[1]);

        }
        csvReader.close();
        Scanner scanner = new Scanner(System.in);
        while (true) {
            String commend = scanner.nextLine();
            String[] set = commend.split(" ");

            if (commend.contains("create")) {
                if (jedis.get(set[1]) == null) {
                    jedis.set(set[1], set[2]);
                    System.out.println("true");
                } else System.out.println("false");
            } else if (commend.contains("fetch")) {
                if (jedis.get(set[1]) != null) {
                    System.out.println("true");
                    System.out.println(jedis.get(set[1]));
                } else System.out.println("false");
            } else if (commend.contains("delete")) {
                if (jedis.get(set[1]) != null) {
                    jedis.del(set[1]);
                    System.out.println("true");
                } else System.out.println("false");
            } else if (commend.contains("update")) {
                if (jedis.get(set[1]) != null) {
                    jedis.del(set[1]);
                    jedis.set(set[1], set[2]);
                    System.out.println("true");
                } else System.out.println("false");
            }
        }
    }
}