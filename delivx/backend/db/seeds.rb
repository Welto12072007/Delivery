# Seeds para DelivX - Dados de exemplo

# Limpar dados existentes
puts "Limpando dados existentes..."
OrderItem.destroy_all
Order.destroy_all
Food.destroy_all
RestaurantCategory.destroy_all
Restaurant.destroy_all
Category.destroy_all
User.destroy_all

# Criar categorias
puts "Criando categorias..."
categories = [
  { name: "Hamburguers", description: "Deliciosos hamburguers artesanais" },
  { name: "Pizza", description: "Pizzas tradicionais e especiais" },
  { name: "Comida Brasileira", description: "Pratos típicos da culinária brasileira" },
  { name: "Japonesa", description: "Sushi, sashimi e pratos japoneses" },
  { name: "Italiana", description: "Massas, risotos e pratos italianos" },
  { name: "Mexicana", description: "Tacos, burritos e comida mexicana" },
  { name: "Sobremesas", description: "Doces, bolos e sobremesas" },
  { name: "Bebidas", description: "Refrigerantes, sucos e bebidas" }
]

created_categories = categories.map do |cat_data|
  Category.create!(cat_data)
end

# Criar usuários
puts "Criando usuários..."
admin = User.create!(
  name: "Administrador DelivX",
  email: "admin@delivx.com",
  password: "123456",
  phone: "(51) 99999-9999",
  address: "Rua Principal, 123",
  city: "Taquara",
  state: "RS",
  zip_code: "95600-000",
  role: "admin"
)

restaurant_owner1 = User.create!(
  name: "João Silva",
  email: "joao@burgerhouse.com",
  password: "123456",
  phone: "(51) 98888-8888",
  address: "Av. dos Hamburguers, 456",
  city: "Taquara",
  state: "RS",
  zip_code: "95600-001",
  role: "restaurant_owner"
)

restaurant_owner2 = User.create!(
  name: "Maria Santos",
  email: "maria@pizzaria.com",
  password: "123456",
  phone: "(51) 97777-7777",
  address: "Rua das Pizzas, 789",
  city: "Taquara",
  state: "RS",
  zip_code: "95600-002",
  role: "restaurant_owner"
)

customer = User.create!(
  name: "Carlos Cliente",
  email: "carlos@email.com",
  password: "123456",
  phone: "(51) 96666-6666",
  address: "Rua dos Clientes, 321",
  city: "Taquara",
  state: "RS",
  zip_code: "95600-003",
  role: "customer"
)

# Criar restaurantes
puts "Criando restaurantes..."
burger_house = Restaurant.create!(
  user: restaurant_owner1,
  name: "Burger House",
  description: "Os melhores hamburguers artesanais da cidade! Ingredientes frescos e selecionados.",
  address: "Av. dos Hamburguers, 456",
  city: "Taquara",
  state: "RS",
  zip_code: "95600-001",
  phone: "(51) 98888-8888",
  delivery_time: "30-45 min",
  delivery_fee: 5.99,
  minimum_order: 15.00,
  rating: 4.8
)

pizzaria_italiana = Restaurant.create!(
  user: restaurant_owner2,
  name: "Pizzaria Italiana",
  description: "Pizzas autênticas com receitas tradicionais italianas. Massa fina e ingredientes importados.",
  address: "Rua das Pizzas, 789",
  city: "Taquara",
  state: "RS",
  zip_code: "95600-002",
  phone: "(51) 97777-7777",
  delivery_time: "25-40 min",
  delivery_fee: 4.99,
  minimum_order: 20.00,
  rating: 4.9
)

comida_caseira = Restaurant.create!(
  user: restaurant_owner1,
  name: "Sabores da Casa",
  description: "Comida caseira fresquinha todos os dias. Tempero da vovó e carinho em cada prato.",
  address: "Rua da Tradição, 147",
  city: "Taquara", 
  state: "RS",
  zip_code: "95600-004",
  phone: "(51) 95555-5555",
  delivery_time: "40-60 min",
  delivery_fee: 6.50,
  minimum_order: 18.00,
  rating: 4.7
)

# Associar categorias aos restaurantes
burger_house.categories << [created_categories[0], created_categories[7]] # Hamburguers, Bebidas
pizzaria_italiana.categories << [created_categories[1], created_categories[4], created_categories[6]] # Pizza, Italiana, Sobremesas
comida_caseira.categories << [created_categories[2], created_categories[6]] # Comida Brasileira, Sobremesas

# Criar comidas para Burger House
puts "Criando comidas para Burger House..."
Food.create!([
  {
    restaurant: burger_house,
    category: created_categories[0],
    name: "X-Bacon Artesanal",
    description: "Hambúrguer artesanal 180g, bacon crocante, queijo cheddar, alface, tomate e molho especial",
    price: 24.90,
    available: true
  },
  {
    restaurant: burger_house,
    category: created_categories[0],
    name: "Burger Duplo",
    description: "Dois hambúrgueres artesanais 120g cada, queijo, picles, cebola e molho barbecue",
    price: 32.90,
    available: true
  },
  {
    restaurant: burger_house,
    category: created_categories[0],
    name: "Chicken Burger",
    description: "Peito de frango grelhado, queijo, alface, tomate e maionese temperada",
    price: 21.90,
    available: true
  },
  {
    restaurant: burger_house,
    category: created_categories[7],
    name: "Coca-Cola 350ml",
    description: "Refrigerante Coca-Cola gelado",
    price: 4.50,
    available: true
  }
])

# Criar comidas para Pizzaria Italiana
puts "Criando comidas para Pizzaria Italiana..."
Food.create!([
  {
    restaurant: pizzaria_italiana,
    category: created_categories[1],
    name: "Pizza Margherita",
    description: "Molho de tomate, mussarela, manjericão fresco e azeite extra virgem",
    price: 35.90,
    available: true
  },
  {
    restaurant: pizzaria_italiana,
    category: created_categories[1],
    name: "Pizza Pepperoni",
    description: "Molho de tomate, mussarela e pepperoni importado",
    price: 39.90,
    available: true
  },
  {
    restaurant: pizzaria_italiana,
    category: created_categories[4],
    name: "Lasanha Bolonhesa",
    description: "Lasanha tradicional com molho bolonhesa e queijos especiais",
    price: 28.90,
    available: true
  },
  {
    restaurant: pizzaria_italiana,
    category: created_categories[6],
    name: "Tiramisu",
    description: "Sobremesa italiana tradicional com café e mascarpone",
    price: 12.90,
    available: true
  }
])

# Criar comidas para Sabores da Casa
puts "Criando comidas para Sabores da Casa..."
Food.create!([
  {
    restaurant: comida_caseira,
    category: created_categories[2],
    name: "Feijoada Completa",
    description: "Feijoada tradicional com acompanhamentos: arroz, farofa, couve e laranja",
    price: 26.90,
    available: true
  },
  {
    restaurant: comida_caseira,
    category: created_categories[2],
    name: "Bife à Parmegiana",
    description: "Bife empanado com molho de tomate, queijo e acompanha arroz e batata frita",
    price: 23.90,
    available: true
  },
  {
    restaurant: comida_caseira,
    category: created_categories[2],
    name: "Escondidinho de Carne Seca",
    description: "Carne seca desfiada, purê de mandioca e queijo gratinado",
    price: 22.90,
    available: true
  },
  {
    restaurant: comida_caseira,
    category: created_categories[6],
    name: "Pudim Caseiro",
    description: "Pudim de leite condensado feito na casa, receita da vovó",
    price: 8.90,
    available: true
  }
])

puts "Seeds executados com sucesso!"
puts "Usuários criados:"
puts "- Admin: admin@delivx.com / 123456"
puts "- Dono Burger House: joao@burgerhouse.com / 123456"
puts "- Dona Pizzaria: maria@pizzaria.com / 123456"
puts "- Cliente: carlos@email.com / 123456"
puts ""
puts "#{Category.count} categorias criadas"
puts "#{Restaurant.count} restaurantes criados"
puts "#{Food.count} comidas criadas"
