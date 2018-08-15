DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
---------------------------
CREATE TABLE customers (
  id SERIAL8 PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
  -- order_id INT8 REFERENCES orders(id)
);

CREATE TABLE orders (
  id SERIAL8 PRIMARY KEY,
  quantity INT2 NOT NULL,
  topping VARCHAR(255) NOT NULL,
  customer_order_id INT8 REFERENCES customers(id)
);
