#!/bin/bash

# DelivX Setup Script
echo "🚀 Configurando o projeto DelivX..."

# Verificar se o Ruby está instalado
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby não encontrado. Por favor, instale o Ruby 3.0.0 ou superior."
    exit 1
fi

# Verificar se o Bundler está instalado
if ! command -v bundle &> /dev/null; then
    echo "📦 Instalando Bundler..."
    gem install bundler
fi

# Navegar para o diretório do backend
cd backend

echo "📦 Instalando gems..."
bundle install

echo "🗄️  Criando banco de dados..."
rails db:create

echo "🔄 Executando migrações..."
rails db:migrate

echo "🌱 Populando banco com dados de exemplo..."
rails db:seed

echo "✅ Configuração concluída!"
echo ""
echo "Para iniciar o servidor Rails:"
echo "  cd backend"
echo "  rails server"
echo ""
echo "Para abrir o frontend:"
echo "  Abra frontend/index.html no navegador"
echo "  ou execute um servidor local na pasta frontend"
echo ""
echo "🎉 DelivX está pronto para uso!"
