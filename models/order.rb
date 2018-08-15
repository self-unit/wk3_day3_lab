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
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "INSERT INTO orders
          (quantity, topping, customer_order_id)
          VALUES
          ($1, $2, $3) RETURNING id"
    values = [@quantity, @topping, @customer_order_id]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]['id'].to_i
    db.close()
  end

  def delete() #instance method
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "DELETE FROM orders
          WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close()
  end

  def update()
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "UPDATE orders
          SET
          (quantity, topping, customer_order_id) =
          ($1, $2, $3)
          WHERE id = $4"
    values = [@quantity, @topping, @customer_order_id, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def find_by_id()
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "SELECT * FROM customers
    WHERE id = $1"
    values = [@customer_order_id]
    db.prepare("find_by_id", sql)
    found_customer = db.exec_prepared("find_by_id", values)
    db.close()
    return Customer.new(found_customer[0])
  end

  def PizzaOrder.all() #class method
    db = PG.connect({dbname: 'pizza_shop', host: 'localhost'})
    sql = "SELECT * FROM orders"
    db.prepare("all", sql)
    orders = db.exec_prepared("all")
    db.close()
    return orders.map {|order| PizzaOrder.new(order)}
  end

  def PizzaOrder.read(id) #class method
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "SELECT * FROM orders
          WHERE id = $1"
    values = [id]
    db.prepare("read_one", sql)
    order = db.exec_prepared("read_one", values)
    db.close()
    return order[0]
  end

  def PizzaOrder.delete_all()
    db = PG.connect ({dbname: 'pizza_shop', host: 'localhost'})
    sql = "DELETE FROM orders"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

end
