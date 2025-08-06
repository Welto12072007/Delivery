# DelivX - Aplicativo de Delivery Similar ao iFood

## 📱 Sobre o Projeto

DelivX é um aplicativo de delivery de comida desenvolvido em Ruby on Rails (backend) e HTML/CSS/JavaScript (frontend), inspirado no iFood. O projeto oferece uma plataforma completa para pedidos de comida online.

## 🚀 Tecnologias Utilizadas

### Backend (Ruby on Rails API)
- **Ruby** 3.0.0
- **Rails** 7.0
- **SQLite3** (desenvolvimento)
- **BCrypt** (autenticação)
- **JWT** (tokens de autenticação)
- **Kaminari** (paginação)
- **Active Storage** (upload de imagens)
- **Rack CORS** (Cross-Origin Resource Sharing)

### Frontend
- **HTML5**
- **CSS3** com **Tailwind CSS**
- **JavaScript** (Vanilla)
- **Font Awesome** (ícones)

## 🏗️ Estrutura do Projeto

```
delivx/
├── backend/           # API Ruby on Rails
│   ├── app/
│   │   ├── controllers/
│   │   ├── models/
│   │   └── services/
│   ├── config/
│   ├── db/
│   │   ├── migrate/
│   │   └── seeds.rb
│   └── Gemfile
└── frontend/          # Interface do usuário
    ├── index.html
    ├── styles.css
    └── script.js
```

## 📋 Funcionalidades

### Para Clientes
- ✅ Cadastro e autenticação de usuários
- ✅ Busca de restaurantes e comidas
- ✅ Filtragem por categorias
- ✅ Visualização de cardápios
- ⏳ Carrinho de compras
- ⏳ Realização de pedidos
- ⏳ Acompanhamento de entregas

### Para Restaurantes
- ✅ Cadastro de restaurantes
- ✅ Gerenciamento de cardápio
- ✅ Upload de imagens
- ⏳ Gestão de pedidos
- ⏳ Relatórios de vendas

### Para Administradores
- ✅ Gestão de usuários
- ✅ Gestão de restaurantes
- ✅ Gestão de categorias
- ⏳ Relatórios gerais

## 🛠️ Instalação e Configuração

### Pré-requisitos
- Ruby 3.0.0+
- Rails 7.0+
- SQLite3
- Node.js (para assets, se necessário)

### Backend (Ruby on Rails)

1. **Instalar dependências:**
   ```bash
   cd backend
   bundle install
   ```

2. **Configurar banco de dados:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Iniciar servidor:**
   ```bash
   rails server
   ```

O servidor estará disponível em `http://localhost:3000`

### Frontend

1. **Abrir no navegador:**
   ```bash
   cd frontend
   # Abrir index.html no navegador ou usar um servidor local
   python -m http.server 8080
   # ou
   npx serve .
   ```

O frontend estará disponível em `http://localhost:8080`

## 📊 Banco de Dados

### Principais Tabelas
- **users** - Usuários (clientes, proprietários, admins)
- **restaurants** - Restaurantes cadastrados
- **categories** - Categorias de comida
- **foods** - Comidas disponíveis
- **orders** - Pedidos realizados
- **order_items** - Itens dos pedidos

## 🔗 Rotas da API

### Autenticação
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/register` - Cadastro
- `DELETE /api/v1/auth/logout` - Logout

### Usuários
- `GET /api/v1/users` - Listar usuários
- `GET /api/v1/users/:id` - Buscar usuário
- `POST /api/v1/users` - Criar usuário
- `PUT /api/v1/users/:id` - Atualizar usuário
- `DELETE /api/v1/users/:id` - Deletar usuário

### Restaurantes
- `GET /api/v1/restaurants` - Listar restaurantes
- `GET /api/v1/restaurants/:id` - Buscar restaurante
- `POST /api/v1/restaurants` - Criar restaurante
- `PUT /api/v1/restaurants/:id` - Atualizar restaurante
- `DELETE /api/v1/restaurants/:id` - Deletar restaurante

### Comidas
- `GET /api/v1/foods` - Listar comidas
- `GET /api/v1/restaurants/:restaurant_id/foods` - Comidas do restaurante
- `GET /api/v1/foods/:id` - Buscar comida
- `POST /api/v1/foods` - Criar comida
- `PUT /api/v1/foods/:id` - Atualizar comida
- `DELETE /api/v1/foods/:id` - Deletar comida

## 👥 Dados de Exemplo

Após executar `rails db:seed`, você terá:

### Usuários de Teste
- **Admin:** admin@delivx.com / 123456
- **Dono Burger House:** joao@burgerhouse.com / 123456
- **Dona Pizzaria:** maria@pizzaria.com / 123456
- **Cliente:** carlos@email.com / 123456

### Restaurantes
- **Burger House** - Hamburguers artesanais
- **Pizzaria Italiana** - Pizzas autênticas
- **Sabores da Casa** - Comida caseira

### Categorias
- Hamburguers
- Pizza
- Comida Brasileira
- Japonesa
- Italiana
- Mexicana
- Sobremesas
- Bebidas

## 🎨 Interface

A interface foi desenvolvida com design responsivo, seguindo os padrões modernos:

- **Design Mobile-First**
- **Cores:** Laranja (#ea580c) e vermelho (#dc2626)
- **Tipografia:** Inter (via Tailwind)
- **Ícones:** Font Awesome
- **Layout:** Grid responsivo

## 🔧 Próximas Implementações

- [ ] Sistema de carrinho completo
- [ ] Processamento de pagamentos
- [ ] Notificações push
- [ ] Chat entre cliente e restaurante
- [ ] Sistema de avaliações
- [ ] Programa de fidelidade
- [ ] App mobile (React Native)
- [ ] Dashboard analítico
- [ ] Integração com mapas

## 📝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Contato

- **Projeto:** DelivX
- **Desenvolvido em:** Taquara, RS
- **Ano:** 2025

---

**DelivX** - Conectando você aos melhores sabores da cidade! 🍔🍕🥘
