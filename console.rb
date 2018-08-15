require('pry-byebug')
require_relative('models/order')
require_relative('models/customer')

#Customer.delete_all()

customer1 = Customer.new({
  'first_name' => 'Boba',
  'last_name' => 'Fett',
  })

  customer2 = Customer.new({
    'first_name' => 'Ben',
    'last_name' => 'Harvie',
    })

    customer3 = Customer.new({
      'first_name' => 'Jesse',
      'last_name' => 'Hurtado',
      })

      customer1.save()
      customer2.save()
      customer3.save()

      customers = Customer.all()

      order1 = PizzaOrder.new({
        'customer_order_id' => '1',
        'quantity' => '1',
        'topping' => 'Napoli'
        })

        order2 = PizzaOrder.new({
          'customer_order_id' => '2',
          'quantity' => '1',
          'topping' => 'Quattro Formaggi'
          })

          order3 = PizzaOrder.new({
            'customer_order_id' => '3',
            'quantity' => '1',
            'topping' => 'Meatiliscious'
            })

            order4 = PizzaOrder.new({
              'customer_order_id' => '1',
              'quantity' => '2',
              'topping' => 'Garden Party'
              })

              order1.save()
              order2.save()
              order3.save()

              orders = PizzaOrder.all()

              binding.pry
              nil
