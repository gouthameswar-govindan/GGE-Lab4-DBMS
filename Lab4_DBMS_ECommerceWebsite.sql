# An E-commerce website manages its data in the form of various tables.

create database if not exists `order-directory`;
use `order-directory`;

/*1) To create Tables for the supplier,customer,category,product,product_Details,order,rating ;to store the data for the E-commerce order directory */
# Table Creation:
create table if not exists Supplier(SUPP_ID int primary key,SUPP_NAME varchar(50),SUPP_CITY varchar(50),SUPP_PHONE varchar(10));

create table if not exists Customer(CUS_ID int primary key,CUS_NAME varchar(50),CUS_PHONE varchar(10),CUS_CITY varchar(30),CUS_GENDER char);

create table if not exists Category(CAT_ID int primary key, CAT_NAME varchar(50));

create table if not exists Product(PRO_ID int primary key ,PRO_NAME varchar(50) null default null ,PRO_DESC varchar(60) null default null ,CAT_ID int not null, foreign key (CAT_ID) references Category(CAT_ID));

create table if not exists Product_Details(PROD_ID int primary key,PRO_ID int not null,SUPP_ID int not null,PROD_PRICE int not null, foreign key (PRO_ID) references Product(PRO_ID),foreign key (SUPP_ID) references Supplier(SUPP_ID));

create table if not exists `Order`(ORD_ID int primary key,ORD_AMOUNT int not null ,ORD_DATE date ,CUS_ID int not null ,PROD_ID int not null, foreign key (PROD_ID) references ProductDetails(PROD_ID),foreign key (CUS_ID) references Customer(CUS_ID));

create table if not exists Rating(RAT_ID int primary key ,RAT_RATSTARS int not null,CUS_ID int not null ,SUPP_ID int not null,foreign key (CUS_ID) references Customer(CUS_ID),foreign key (SUPP_ID) references Supplier(SUPP_ID) );

/*2) Insertion of data records in the tables created above */
# Insertion- Supplier Table:
insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

# Insertion- Customer Table:
INSERT INTO `CUSTOMER` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `CUSTOMER` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `CUSTOMER` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `CUSTOMER` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `CUSTOMER` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

# Insertion- Category Table:
INSERT INTO `CATEGORY` VALUES( 1,"BOOKS");
INSERT INTO `CATEGORY` VALUES(2,"GAMES");
INSERT INTO `CATEGORY` VALUES(3,"GROCERIES");
INSERT INTO `CATEGORY` VALUES (4,"ELECTRONICS");
INSERT INTO `CATEGORY` VALUES(5,"CLOTHES");

# Insertion- Product Table:
INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

# Insertion- Product_Details Table:
INSERT INTO `PRODUCT_DETAILS` VALUES(1,1,2,1500);
INSERT INTO `PRODUCT_DETAILS` VALUES(2,3,5,30000);
INSERT INTO `PRODUCT_DETAILS` VALUES(3,5,1,3000);
INSERT INTO `PRODUCT_DETAILS` VALUES(4,2,3,2500);
INSERT INTO `PRODUCT_DETAILS` VALUES(5,4,1,1000);

# Insertion- Order Table:
INSERT INTO `ORDER` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `ORDER` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `ORDER` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `ORDER` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `ORDER` VALUES(30,3500,"2021-08-16",4,3);

# Insertion- Rating Table:
INSERT INTO `RATING` VALUES(1,2,2,4);
INSERT INTO `RATING` VALUES(2,3,4,3);
INSERT INTO `RATING` VALUES(3,5,1,5);
INSERT INTO `RATING` VALUES(4,1,3,2);
INSERT INTO `RATING` VALUES(5,4,5,4);
#Queries:
/*3) To Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000 */
select cust.cus_gender , count(cust.cus_gender) as count from customer cust inner join `order` on cust.cus_id = `order`.cus_id where `order`.ord_amount >= 3000 group by cust.cus_gender;

/*4) To Display all the orders along with the product name ordered by a customer having Customer_Id=2 */
select `order`.*, product.pro_name from `order`, product_details, product where `order` .cus_id = 2 and `order` .prod_id = product_details.prod_id and product_details.prod_id = product.pro_id;

/*5) Display the Supplier details who can supply more than one product*/
select supplier.* from supplier, product_details where supplier.supp_id in (select product_details.supp_id from product_details group by product_details.supp_id having count(product_details.supp_id) > 1) group by supplier.supp_id;

/*6) To Find the category of the product whose order amount is minimum*/
select category.* from `order` inner join product_details on `order`.prod_id = product_details.prod_id inner join product on product.pro_id = product_details.pro_id inner join category on category.cat_id = product.cat_id order by `order`.ORD_AMOUNT limit 1;

/*7) To Display the Id and Name of the Product ordered after “2021-10-05”*/
select product.pro_id, product.pro_name from `order` inner join product_details on `order` .prod_id = product_details.prod_id inner join product on product.pro_id = product_details.pro_id where `order`.ord_date > '2021-10-5';

/*8) To Display customer name and gender whose names start or end with character 'A'*/
select cust.cus_name, cust.cus_gender from customer cust where cust.cus_name like 'A%' or cust.CUS_NAME like '&A';

/*To Display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.*/
select supplier.supp_id, supplier.supp_name, rating.rat_ratstars, case
when rating.rat_ratstars > 4 then 'Genuine Supplier'
when rating.rat_ratstars > 2 then 'Average Supplier'
else 'Supplier should not be considered'
end as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;


/*9) To Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.*/
call display_rating_supplier();
