-- FILEPATH: /C:/DBT/jaffle_shop/models/example/customers.sql

WITH CUSTOMERS AS (

    SELECT
        ID AS Customer_Id,
        First_Name,
        Last_Name

    FROM raw.jaffle_shop.customers

),

ORDERS AS (

    SELECT
        ID AS Order_Id,
        User_ID AS Customer_Id,
        Order_Date,
        status

    FROM raw.jaffle_shop.orders

),

CUSTOMER_ORDERS AS (

    SELECT
        Customer_Id,

        MIN(Order_Date) AS First_Order_Date,
        MAX(Order_Date) AS Most_Recent_Order_Date,
        COUNT(Order_Id) AS Number_of_Orders

    FROM ORDERS

    GROUP BY 1 -- Customer_Id

),

FINAL AS (
    
        SELECT
            CUSTOMERS.Customer_Id,
            CUSTOMERS.First_Name,
            CUSTOMERS.Last_Name,
    
            CUSTOMER_ORDERS.First_Order_Date,
            CUSTOMER_ORDERS.Most_Recent_Order_Date,
            COALESCE(CUSTOMER_ORDERS.Number_of_Orders, 0) AS Number_of_Orders
    
        FROM CUSTOMERS
    
        LEFT JOIN CUSTOMER_ORDERS
            ON CUSTOMERS.Customer_Id = CUSTOMER_ORDERS.Customer_Id
    
    )
SELECT * FROM FINAL
