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
    sql = "DELETE FROM customers WHERE
    id = $1"
    values = [@id]
    returned_array = SqlRunner.run(sql, values)
  end

  def find_by_order_id()
    sql = "SELECT * FROM orders
    WHERE customer_order_id = $1"
    values = [@id]
    returned_array = SqlRunner.run(sql, values)
    return returned_array.map {|order| PizzaOrder.new(order)}
  end

  def Customer.all
    sql = "SELECT * FROM customers"
    returned_array = SqlRunner.run(sql)
    return returned_array.map {|customer| Customer.new(customer)}
  end

  def Customer.delete_all
    sql = "DELETE FROM customers"
    returned_array = SqlRunner.run(sql)
  end

end
