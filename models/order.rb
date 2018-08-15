require('pg')

class PizzaOrder
  attr_accessor :quantity, :topping, :customer_order_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_order_id = options['customer_order_id'].to_i if options['customer_order_id']
    @quantity = options['quantity'].to_i
    @topping = options['topping']
  end

  def save()
    sql = "INSERT INTO orders
          (quantity, topping, customer_order_id)
          VALUES
          ($1, $2, $3) RETURNING id"
    values = [@quantity, @topping, @customer_order_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def delete() #instance method
    sql = "DELETE FROM orders
          WHERE id = $1"
    values = [@id]
    returned_array = SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE orders
          SET
          (quantity, topping, customer_order_id) =
          ($1, $2, $3)
          WHERE id = $4"
    values = [@quantity, @topping, @customer_order_id, @id]
    returned_array = SqlRunner.run(sql, values)
  end

  def find_by_id()
    sql = "SELECT * FROM customers
    WHERE id = $1"
    values = [@customer_order_id]
    returned_array = SqlRunner.run(sql, values)
    return Customer.new(returned_array[0])
  end

  def PizzaOrder.all() #class method
    sql = "SELECT * FROM orders"
    orders = SqlRunner.run(sql)
    return orders.map {|order| PizzaOrder.new(order)}
  end

  def PizzaOrder.read(id) #class method
    sql = "SELECT * FROM orders
          WHERE id = $1"
    values = [id]
    order = SqlRunner.run(sql)
    return order[0]
  end

  def PizzaOrder.delete_all()
    sql = "DELETE FROM orders"
    returned_array = SqlRunner.run(sql)
  end

end
