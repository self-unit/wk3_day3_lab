require('pg')
require_relative('./order.rb')
require_relative('../db/sql_runner.rb')

class Customer

  attr_accessor :first_name, :last_name
  attr_reader :id

  def initialize(options)
    # @order_id = options['order_id'].to_i if options['order_id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @id = options['id'].to_i if options['id']
  end

  def save
   sql = "INSERT INTO customers
          (first_name, last_name)
          VALUES
          ($1, $2) RETURNING *"
    values = [@first_name, @last_name]
    returned_array = SqlRunner.run(sql, values)
    customer_hash = returned_array[0]
    id_string = customer_hash['id']
    @id = id_string.to_i
  end

  def update
    sql = "UPDATE customers SET (first_name, last_name)
    = ($1, $2)
    WHERE id = $3"
    values = [@first_name, @last_name, @id]
    returned_array = SqlRunner.run(sql, values)
  end

  def delete
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "DELETE FROM customers WHERE
    id = $1"
    values = [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete", values)
    db.close()
  end

  def find_by_order_id()
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "SELECT * FROM orders
    WHERE customer_order_id = $1"
    values = [@id]
    db.prepare("find_by_order_id", sql)
    found_orders = db.exec_prepared("find_by_order_id", values)
    db.close()
    return found_orders.map {|order| PizzaOrder.new(order)}
  end

  def Customer.all
    db = PG.connect({dbname: 'pizza_shop', host: 'localhost'})
    sql = "SELECT * FROM customers"
    db.prepare("all", sql)
    customers = db.exec_prepared("all")
    db.close()
    return customers.map {|customer| Customer.new(customer)}
  end

  def Customer.delete_all
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "DELETE FROM customers"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

end
