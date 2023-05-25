load from "XOM.csv" of del method P(1, 2, 3, 4, 5, 6, 7) insert into CSE532.STOCK(Date, Open, High, Low, Close, AdjClose, Volume);
update CSE532.STOCK set StockName = 'XOM' where StockName is NULL;
load from "AAL.csv" of del method P(1, 2, 3, 4, 5, 6, 7) insert into CSE532.STOCK(Date, Open, High, Low, Close, AdjClose, Volume);
update CSE532.STOCK set StockName = 'AAL' where StockName IS NULL;