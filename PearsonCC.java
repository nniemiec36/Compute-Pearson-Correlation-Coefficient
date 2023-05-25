import java.sql.*;
import java.util.*;
public class PearsonCC {
    private Connection connection = null;
    private PreparedStatement statement = null;

    public void setDatabaseConnection(String url, String user, String password) {
        try {
            Class.forName("com.ibm.db2.jcc.DB2Driver").getDeclaredConstructor().newInstance();
        connection = DriverManager.getConnection(url, user, password);
	} catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void calculatePearsonCC(String s1, String s2, String tablename){
        try {
	        statement = connection.prepareStatement("SELECT x, y FROM ( SELECT s.Close as x, t.close as y FROM ? s INNER JOIN ? t ON s.Date = t.Date and s.StockName = ? AND t.StockName = ?)");

            statement.setString(1, tablename);
	        statement.setString(2, tablename);
            statement.setString(3, s1);
            statement.setString(4,s2);
            System.out.println("Statement: "+statement);
	        ResultSet rs = statement.executeQuery();
            List<Double> stock1 = new ArrayList<Double>();
            List<Double> stock2 = new ArrayList<Double>();
            while(rs.next()) {
                stock1.add(Double.parseDouble(rs.getString(1)));
                stock2.add(Double.parseDouble(rs.getString(2)));
            }
            double cc = calculate(stock1, stock2);
            System.out.println("Pearson CC = " + cc);
            rs.close();
            statement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public double calculate(List<Double> x, List<Double> y) {

        double xSum = 0;
        double ySum = 0;
        double xSquaredSum = 0;
        double ySquaredSum = 0;
        double xySum = 0;
        double n = 0;
        double x1 = 0;
        double y1 = 0;

        for(int i = 0; i < x.size(); i++){
            x1 = x.get(i);
            y1 = y.get(i);
            xSum = xSum + x1;
            xSquaredSum = xSquaredSum + (x1 * x1);
            xySum = xySum + (x1 * y1);
            ySum = ySum + y1;
            ySquaredSum = ySquaredSum + (y1 * y1);
            n = n + 1;
        }

        double numerator = (n * xySum) - (xSum * ySum);
        double denominator = ((n * xSquaredSum) - (xSum * xSum)) * ((n * ySquaredSum) - (ySum * ySum));
        denominator = Math.sqrt(denominator);
        return (numerator/denominator);

    }

    public static void main(String[] args) {
        String db = args[0];
        String dbURL = "jdbc:db2://localhost:5000/" + db;
        String tablename = args[1];
        String user = args[2];
        String password = args[3];
        String stock1 = args[4];
        String stock2 = args[5];

        PearsonCC pearson = new PearsonCC();
        pearson.setDatabaseConnection(dbURL, user, password);
        pearson.calculatePearsonCC(stock1, stock2, tablename);


    }
}
