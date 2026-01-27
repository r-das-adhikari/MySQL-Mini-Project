--                                                     Questions
--                                                   Level 1: Basics

-- 1. Retrieve customer names and emails for email marketing
select * from customers;
select name,email from customers;

-- 2. View complete product catalog with all available details
select * from products;

-- 3. List all unique product categories
select distinct category from products;

-- 4. Show all products priced above ₹1,000
select * from products where price > 1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
select * from products where price >= 2000 and price <=5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
select * from customers;
select * from customers where customer_id in (3,6,7,8,15,20) ; # assumimg my loyalty lis as (3,6,7,8,15,20)

-- 7. Identify customers whose names start with the letter ‘A’
select * from customers where name like 'A%';

-- 8. List electronics products priced under ₹3,000
select * from products;
select * from products where category ='Electronics' and price <3000;

-- 9. Display product names and prices in descending order of price
select name ,price from products order by price desc;

-- 10. Display product names and prices, sorted by price and then by name
select name ,price from products order by price desc ,name asc ;

--                                                  Level 2: Filtering and Formatting

-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion)
select * from orders;
select * from orders where customer_id is null;

-- 2. Display customer names and emails using column aliases for frontend readability
select name as 'Customer Name',email as 'Email ID' from customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
select * from products;
select *,price*stock_quantity as 'Total Value' from products;

-- 4. Combine customer name and phone number in a single column
select * from customers;
select concat(name ,'-->',phone) as customer_info from customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
select * from orders;
select order_id ,customer_id,date(order_date) as 'Date' from orders;

-- 6. List products that do not have any stock left
select* from products;
select *from products where stock_quantity =0;

--                                                        Level 3: Aggregations

-- 1. Count the total number of orders placed
select count(*) from orders;

-- 2. Calculate the total revenue collected from all orders
select * from orders;
select sum(total_amount) as Total_revenue from orders;

-- 3. Calculate the average order value
select avg(total_amount) as Average_order_value from orders;

-- 4. Count the number of customers who have placed at least one order
select count(distinct customer_id ) as Active_customer_count from orders;

-- 5. Find the number of orders placed by each customer
select customer_id ,count(order_id) from orders group by customer_id ;

-- 6. Find total sales amount made by each customer
select c.name as Customer_Name,
       sum(o.total_amount) as Total_sale_amount 
from orders o
inner join customers c on c.customer_id =o.customer_id
group by c.name,c.customer_id;

-- 7. List the number of products sold per category
select * from products;
select* from order_items;
select p.category,
       sum(oi.quantity)as Total_sale_count
from products p 
join order_items oi on p.product_id=oi.product_id
group by p.category;

-- 8. Find the average item price per category
select * from order_items;
select * from products;
select category,
       avg(item_price)
from products p 
join order_items oi on oi.product_id=p.product_id
group by category;

-- 9. Show number of orders placed per day
select * from orders;
select * from order_items;

select date(order_date) as Order_day,
       count(order_id) as order_count
from orders 
group by date(order_date);

-- 10. List total payments received per payment method
select * from payments;
select method as Payment_Method,
       sum(amount_paid) as Total_payment
from payments
group by method ;



--                                                   Level 4: Multi-Table Queries (JOINS)

-- 1. Retrieve order details along with the customer name (INNER JOIN)
select * from customers;
select * from orders;

select c.name,o.*
from customers c
join orders o on c.customer_id =o.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items)
select*from order_items;
select* from products;

select name,category, 
            sum(oi.item_price*oi.quantity) as Total_amount
from order_items oi 
join products p on p.product_id=oi.product_id
group by name,category
order by Total_amount desc;

-- 3. List all orders with their payment method (INNER JOIN)
select * from orders;
select *from payments;

select o.order_id,
       o.customer_id,
       p.amount_paid,
       p.method
from orders o 
join payments p on p.order_id=o.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)
select * from orders;

select name as Customer_name,o.*
from customers c 
left join orders o on o.customer_id=c.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN)
select * from products;
select * from order_items;

select p.product_id,
       p.name,
       p.category,
       p.price,
       oi.quantity
from products p 
left join order_items oi on p.product_id=oi.product_id;

-- 6. List all payments including those with no matching orders (RIGHT JOIN)
select* from payments;
select o.order_id ,
       o.customer_id,
       p.payment_id,
       p.amount_paid,
       p.method
from orders o 
right join payments p on p.order_id= o.order_id;

-- 7. Combine data from three tables: customer, order, and payment
select * from customers;
select * from orders;
select * from payments;

select c.customer_id,
	c.name AS Customer_Name,
    c.email,
    c.phone,
    c.created_at,
    o.order_id,
    o.order_date,
    o.status,
    p.method AS Payment_Method,
    p.amount_paid
from customers c 
join orders o on c.customer_id =o.customer_id
join payments p on o.order_id=p.order_id;

--                                               Level 5: Subqueries (Inner Queries)

-- 1. List all products priced above the average product price 
select * from products;
select * from products 
where  price > (select avg(price) from products);

-- 2. Find customers who have placed at least one order 
select * from customers;
select * from orders;

select name as Customer_name from customers 
where customer_id in (select customer_id from orders);

-- 3. Show orders whose total amount is above the average for that customer 
select o1.order_id ,
       o1.customer_id ,
       o1.total_amount
from orders o1
where total_amount > (
select avg(total_amount) 
from orders o2
where o1.customer_id=o2.customer_id);

-- 4. Display customers who haven’t placed any orders 
select * from customers
where customer_id not in (
select customer_id from orders
);

-- 5. Show products that were never ordered 
select * from products;
select * from order_items;

select * from products 
where product_id not in (
select product_id from order_items);



-- 6. Show highest value order per customer
 
-- 7. Highest Order Per Customer (Including Names)


--                                                Level 6: Set Operations

-- 1. List all customers who have either placed an order or written a product review

-- 2. List all customers who have placed an order as well as reviewed a product [intersect not supported]
 






















