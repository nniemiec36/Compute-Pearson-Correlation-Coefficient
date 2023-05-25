-- Task 2 (4 points).  Implement the Pearson Correlation Coefficient as a stored procedure in SQL/PL. Please consider performance in your implementation. For example, each aggregation query may scan the whole table once, thus SQL aggregation functions should not be used in the stored procedure.  The procedure cse532.PearsonCC (stock1 CHAR(4),  stock2 CHAR(4),  cc DECIMAL(4,3) ) takes two input parameters stock1 and stock2 (close price) and return the correlation coefficient as cc.

-- r = Pearson Coefficient
-- n= number of the pairs of the stock
-- ∑xy = sum of products of the paired stocks
-- ∑x = sum of the x scores
-- ∑y= sum of the y scores
-- ∑x2 = sum of the squared x scores
-- ∑y2 = sum of the squared y scores

CREATE OR REPLACE PROCEDURE pearsonCCsp(
        IN stock1 CHAR(4), IN stock2 CHAR(4), OUT cc DECIMAL(4, 3)
    )
    LANGUAGE SQL
    BEGIN
        DECLARE x_sum FLOAT;
        DECLARE y_sum FLOAT;
        DECLARE xy_sum FLOAT;
        DECLARE n FLOAT;
        DECLARE x_squared_sum FLOAT;
        DECLARE y_squared_sum FLOAT;
        DECLARE num FLOAT;
        DECLARE denom FLOAT;

        SET x_sum = 0;
        SET x_squared_sum = 0;
        SET y_sum = 0;
        SET y_squared_sum = 0;
        SET xy_sum = 0;
        SET n = 0;

        -- WITH CTE AS (SELECT s.Close, t.close FROM CSE532.STOCK s INNER JOIN CSE532.STOCK t ON s.Date = t.Date and s.StockName = stock1 AND t.StockName = stock2)
        FOR v1 AS CUR CURSOR FOR
            SELECT x1, y1 FROM (
                SELECT s.Close as x1, t.close as y1 FROM CSE532.STOCK s INNER JOIN CSE532.STOCK t ON s.Date = t.Date and s.StockName = stock1 AND t.StockName = stock2
            )
            DO
                SET x_sum = x_sum + x1;
                SET x_squared_sum = x_squared_sum + (x1 * x1);
                SET xy_sum = xy_sum + (x1 * y1);
                SET y_sum = y_sum + y1;
                SET y_squared_sum = y_squared_sum + (y1 * y1);
                SET n = n + 1;
        END FOR;

        SET num = (n * xy_sum) - (x_sum * y_sum);
        SET denom = ((n * x_squared_sum) - (x_sum * x_sum)) * ((n * y_squared_sum) - (y_sum * y_sum));
        SET denom = SQRT(denom);
        SET cc = num / denom;
        -- SET numerator = num;
        -- SET denominator = denom;
    END@