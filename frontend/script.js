// DelivX Frontend JavaScript

class DelivX {
    constructor() {
        this.apiBaseUrl = 'http://localhost:3000/api/v1';
        this.currentUser = null;
        this.authToken = localStorage.getItem('delivx_token');
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.checkAuthStatus();
        this.loadInitialData();
    }
    
    setupEventListeners() {
        // Login modal
        document.getElementById('login-btn').addEventListener('click', () => {
            this.showLoginModal();
        });
        
        document.getElementById('close-modal').addEventListener('click', () => {
            this.hideLoginModal();
        });
        
        // Login form
        document.getElementById('login-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });
        
        // Search
        document.getElementById('search-input').addEventListener('input', (e) => {
            this.debounce(() => {
                this.handleSearch(e.target.value);
            }, 500)();
        });
        
        // Close modal when clicking outside
        document.getElementById('login-modal').addEventListener('click', (e) => {
            if (e.target.id === 'login-modal') {
                this.hideLoginModal();
            }
        });
    }
    
    checkAuthStatus() {
        if (this.authToken) {
            // Validate token and get user info
            this.validateToken();
        }
    }
    
    async validateToken() {
        try {
            const response = await this.apiCall('/users/me', 'GET');
            if (response.user) {
                this.currentUser = response.user;
                this.updateUIForLoggedUser();
            }
        } catch (error) {
            // Token invalid, remove it
            localStorage.removeItem('delivx_token');
            this.authToken = null;
        }
    }
    
    async loadInitialData() {
        try {
            await Promise.all([
                this.loadCategories(),
                this.loadRestaurants(),
                this.loadRecommendedFoods()
            ]);
        } catch (error) {
            console.error('Error loading initial data:', error);
            this.showToast('Erro ao carregar dados', 'error');
        }
    }
    
    async loadCategories() {
        try {
            const response = await this.apiCall('/categories');
            const categories = response.categories || response;
            
            const container = document.getElementById('categories-container');
            container.innerHTML = categories.map(category => `
                <div class="text-center cursor-pointer card-hover" onclick="delivx.filterByCategory(${category.id})">
                    <div class="category-icon">
                        <i class="${this.getCategoryIcon(category.name)}"></i>
                    </div>
                    <p class="text-sm font-medium text-gray-700">${category.name}</p>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error loading categories:', error);
        }
    }
    
    async loadRestaurants() {
        try {
            const response = await this.apiCall('/restaurants');
            const restaurants = response.restaurants || response;
            
            const container = document.getElementById('restaurants-container');
            container.innerHTML = restaurants.slice(0, 8).map(restaurant => `
                <div class="restaurant-card" onclick="delivx.openRestaurant(${restaurant.id})">
                    <div class="restaurant-image bg-gradient-to-br from-orange-400 to-red-500 flex items-center justify-center">
                        <i class="fas fa-utensils text-white text-3xl"></i>
                    </div>
                    <div class="p-4">
                        <h4 class="font-semibold text-gray-800 mb-1">${restaurant.name}</h4>
                        <p class="text-sm text-gray-600 mb-2">${restaurant.description.substring(0, 60)}...</p>
                        <div class="flex items-center justify-between text-sm">
                            <div class="flex items-center">
                                <div class="rating-stars mr-1">
                                    ${this.generateStars(restaurant.rating)}
                                </div>
                                <span class="font-medium">${restaurant.rating}</span>
                            </div>
                            <span class="text-gray-500">${restaurant.delivery_time}</span>
                        </div>
                        <div class="flex items-center justify-between mt-2">
                            <span class="text-sm text-gray-600">Taxa: R$ ${restaurant.delivery_fee.toFixed(2)}</span>
                            <span class="text-sm text-gray-600">Mín: R$ ${restaurant.minimum_order.toFixed(2)}</span>
                        </div>
                    </div>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error loading restaurants:', error);
        }
    }
    
    async loadRecommendedFoods() {
        try {
            const response = await this.apiCall('/foods');
            const foods = response.foods || response;
            
            const container = document.getElementById('recommended-foods');
            container.innerHTML = foods.slice(0, 8).map(food => `
                <div class="food-card">
                    <div class="food-image bg-gradient-to-br from-yellow-400 to-orange-500 flex items-center justify-center">
                        <i class="fas fa-hamburger text-white text-2xl"></i>
                    </div>
                    <div class="p-4">
                        <h4 class="font-semibold text-gray-800 mb-1">${food.name}</h4>
                        <p class="text-sm text-gray-600 mb-2">${food.description.substring(0, 60)}...</p>
                        <div class="flex items-center justify-between">
                            <span class="price text-lg">${food.formatted_price}</span>
                            <button class="btn-primary text-sm px-3 py-1" onclick="delivx.addToCart(${food.id})">
                                <i class="fas fa-plus mr-1"></i>
                                Adicionar
                            </button>
                        </div>
                        <p class="text-xs text-gray-500 mt-1">${food.restaurant.name}</p>
                    </div>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error loading recommended foods:', error);
        }
    }
    
    async handleLogin() {
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        try {
            const response = await this.apiCall('/auth/login', 'POST', {
                email,
                password
            });
            
            if (response.token) {
                this.authToken = response.token;
                this.currentUser = response.user;
                localStorage.setItem('delivx_token', this.authToken);
                
                this.hideLoginModal();
                this.updateUIForLoggedUser();
                this.showToast(response.message || 'Login realizado com sucesso!', 'success');
            }
        } catch (error) {
            this.showToast(error.message || 'Erro ao fazer login', 'error');
        }
    }
    
    async handleSearch(query) {
        if (query.length < 3) {
            this.loadRestaurants();
            return;
        }
        
        try {
            const response = await this.apiCall(`/restaurants?search=${encodeURIComponent(query)}`);
            const restaurants = response.restaurants || response;
            
            const container = document.getElementById('restaurants-container');
            if (restaurants.length === 0) {
                container.innerHTML = `
                    <div class="col-span-full text-center py-8">
                        <i class="fas fa-search text-gray-400 text-4xl mb-4"></i>
                        <p class="text-gray-600">Nenhum restaurante encontrado para "${query}"</p>
                    </div>
                `;
            } else {
                container.innerHTML = restaurants.map(restaurant => `
                    <div class="restaurant-card" onclick="delivx.openRestaurant(${restaurant.id})">
                        <div class="restaurant-image bg-gradient-to-br from-orange-400 to-red-500 flex items-center justify-center">
                            <i class="fas fa-utensils text-white text-3xl"></i>
                        </div>
                        <div class="p-4">
                            <h4 class="font-semibold text-gray-800 mb-1">${restaurant.name}</h4>
                            <p class="text-sm text-gray-600 mb-2">${restaurant.description.substring(0, 60)}...</p>
                            <div class="flex items-center justify-between text-sm">
                                <div class="flex items-center">
                                    <div class="rating-stars mr-1">
                                        ${this.generateStars(restaurant.rating)}
                                    </div>
                                    <span class="font-medium">${restaurant.rating}</span>
                                </div>
                                <span class="text-gray-500">${restaurant.delivery_time}</span>
                            </div>
                        </div>
                    </div>
                `).join('');
            }
        } catch (error) {
            console.error('Error searching:', error);
        }
    }
    
    async filterByCategory(categoryId) {
        try {
            const response = await this.apiCall(`/restaurants?category_id=${categoryId}`);
            const restaurants = response.restaurants || response;
            
            const container = document.getElementById('restaurants-container');
            container.innerHTML = restaurants.map(restaurant => `
                <div class="restaurant-card" onclick="delivx.openRestaurant(${restaurant.id})">
                    <div class="restaurant-image bg-gradient-to-br from-orange-400 to-red-500 flex items-center justify-center">
                        <i class="fas fa-utensils text-white text-3xl"></i>
                    </div>
                    <div class="p-4">
                        <h4 class="font-semibold text-gray-800 mb-1">${restaurant.name}</h4>
                        <p class="text-sm text-gray-600 mb-2">${restaurant.description.substring(0, 60)}...</p>
                        <div class="flex items-center justify-between text-sm">
                            <div class="flex items-center">
                                <div class="rating-stars mr-1">
                                    ${this.generateStars(restaurant.rating)}
                                </div>
                                <span class="font-medium">${restaurant.rating}</span>
                            </div>
                            <span class="text-gray-500">${restaurant.delivery_time}</span>
                        </div>
                    </div>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error filtering by category:', error);
        }
    }
    
    openRestaurant(restaurantId) {
        // Navigate to restaurant page
        window.location.href = `restaurant.html?id=${restaurantId}`;
    }
    
    addToCart(foodId) {
        if (!this.currentUser) {
            this.showToast('Faça login para adicionar ao carrinho', 'error');
            this.showLoginModal();
            return;
        }
        
        // Add to cart logic
        this.showToast('Item adicionado ao carrinho!', 'success');
    }
    
    showLoginModal() {
        const modal = document.getElementById('login-modal');
        modal.classList.remove('hidden');
        modal.querySelector('.bg-white').classList.add('modal-enter');
    }
    
    hideLoginModal() {
        const modal = document.getElementById('login-modal');
        modal.classList.add('hidden');
        
        // Clear form
        document.getElementById('login-form').reset();
    }
    
    updateUIForLoggedUser() {
        const loginBtn = document.getElementById('login-btn');
        loginBtn.innerHTML = `
            <i class="fas fa-user mr-1"></i>
            ${this.currentUser.name}
        `;
        loginBtn.onclick = () => this.showUserMenu();
    }
    
    showUserMenu() {
        // Show user dropdown menu
        this.showToast('Menu do usuário em desenvolvimento', 'info');
    }
    
    async apiCall(endpoint, method = 'GET', data = null) {
        const url = this.apiBaseUrl + endpoint;
        const options = {
            method,
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        };
        
        if (this.authToken) {
            options.headers['Authorization'] = `Bearer ${this.authToken}`;
        }
        
        if (data && method !== 'GET') {
            options.body = JSON.stringify(data);
        }
        
        try {
            const response = await fetch(url, options);
            const responseData = await response.json();
            
            if (!response.ok) {
                throw new Error(responseData.error || `HTTP error! status: ${response.status}`);
            }
            
            return responseData;
        } catch (error) {
            console.error('API call error:', error);
            throw error;
        }
    }
    
    showToast(message, type = 'info') {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <div class="flex items-center">
                <i class="fas fa-${this.getToastIcon(type)} mr-3"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(toast);
        
        setTimeout(() => {
            toast.remove();
        }, 4000);
    }
    
    getToastIcon(type) {
        const icons = {
            success: 'check-circle',
            error: 'exclamation-circle',
            info: 'info-circle',
            warning: 'exclamation-triangle'
        };
        return icons[type] || 'info-circle';
    }
    
    getCategoryIcon(categoryName) {
        const icons = {
            'Hamburguers': 'fas fa-hamburger',
            'Pizza': 'fas fa-pizza-slice',
            'Comida Brasileira': 'fas fa-leaf',
            'Japonesa': 'fas fa-fish',
            'Italiana': 'fas fa-wine-glass',
            'Mexicana': 'fas fa-pepper-hot',
            'Sobremesas': 'fas fa-ice-cream',
            'Bebidas': 'fas fa-cocktail'
        };
        return icons[categoryName] || 'fas fa-utensils';
    }
    
    generateStars(rating) {
        const fullStars = Math.floor(rating);
        const hasHalfStar = rating % 1 !== 0;
        let stars = '';
        
        for (let i = 0; i < fullStars; i++) {
            stars += '<i class="fas fa-star"></i>';
        }
        
        if (hasHalfStar) {
            stars += '<i class="fas fa-star-half-alt"></i>';
        }
        
        const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
        for (let i = 0; i < emptyStars; i++) {
            stars += '<i class="far fa-star"></i>';
        }
        
        return stars;
    }
    
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
}

// Initialize the app
const delivx = new DelivX();
