AIM - 

Design an ER diagram for an Indian e-commerce platform with entities Customer, Product, Order, OrderItem, Seller, Category, Payment, Delivery, Address. Specify primary keys, composite and multi-valued attributes, weak entities, specialization of Product, and participation constraints. 


Entity	Attributes
CUSTOMER	Customer_ID PK, Name, Email, Phone
ADDRESS	Address_ID PK, House_No, Street, City, State, Country, PinCode
SELLER	Seller_ID PK, Name, Email, Phone, GSTIN
CATEGORY	Category_ID PK, Category_Name, Description, Parent_Category_ID
PRODUCT	Product_ID PK, Name, Description, Price, Stock, Brand, Average_Rating
ORDER	Order_ID PK, Order_Date, Total_Amount, Order_Status
ORDER_ITEM	Order_ID PK/FK, Product_ID PK/FK, Quantity, Unit_Price, Discount
PAYMENT	Payment_ID PK, Payment_Date, Amount, Payment_Method, Payment_Status, Transaction_ID
DELIVERY	Delivery_ID PK, Delivery_Date, Delivery_Status, Tracking_No, Delivery_Partner