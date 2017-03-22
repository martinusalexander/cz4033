BULK INSERT Customer
FROM 'C:\Users\ThawThaw\Desktop\CZ4033\Datas\Customer.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)