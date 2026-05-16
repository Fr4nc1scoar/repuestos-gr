/* =========================================================
   REPUESTOS CR — app.js
   - Catálogo con búsqueda y filtros por categoría
   - Carrito tipo Urban Food (agregar/remover, qty)
   - Checkout Delivery / Pick Up → Envío por WhatsApp
======================================================== */

const WHATSAPP_NUMBER = "584146088160"; // ← Cambia este número

/* ── Emojis por categoría ──────────────────────────── */
const CAT_EMOJI = {
    'ALL':         '🏪',
    'CAPACITORES': '⚡',
    'BIMETALICOS': '🌡️',
    'TERMOSTATOS': '🌡️',
    'COMPRESORES': '🔩',
    'GASES':       '💨',
    'RELOJES':     '⏱️',
    'ROLINERAS':   '⚙️',
    'VARILLAS':    '🔧',
    'FILTROS':     '🗂️',
    'MANGUERAS':   '🔌',
    'ACEITES':     '🛢️',
    'VALVULAS':    '🔑',
    'CONTACTORES': '⚡',
    'PROTECTORES': '🛡️',
    'RESISTENCIAS':'🔴',
    'ELECTRONICA': '📟',
    'MOTORES':     '⚙️',
    'TUBERIAS':    '🔩',
    'SELLANTES':   '🧴',
    'SOLDADURA':   '🔥',
    'AISLANTES':   '🧱',
    'PRESOSTATOS': '📊',
    'MEDICION':    '📏',
    'ACCESORIOS':  '🧰',
    'KITS':        '📦',
    'BOMBAS':      '💧',
    'BOYAS':       '🔵',
    'COCINA':      '🍳',
    'HERRAMIENTAS':'🛠️',
    'OTROS':       '📦',
};

/* ── Estado Global ────────────────────────────────── */
let state = {
    category: 'ALL',
    search: '',
    sort: 'default',
    cart: {},          // { cartKey: { product, qty } }  cartKey = id|brand (unique per variant)
    mode: 'consult',   // Default to consult
};

/* ── Build unique cart key (handles same code / different brand) ── */
function cartKey(product) {
    return `${product.id}|${product.brand}`;
}

/* ── DOM refs ─────────────────────────────────────── */
const $ = id => document.getElementById(id);
const productsGrid   = $('productsGrid');
const categoryList   = $('categoryList');
const searchInput    = $('searchInput');
const clearSearch    = $('clearSearch');
const sortSelect     = $('sortSelect');
const resultsInfo    = $('resultsInfo');
const noResults      = $('noResults');
const cartBtn        = $('cartBtn');
const cartCount      = $('cartCount');
const cartOverlay    = $('cartOverlay');
const cartPanel      = $('cartPanel');
const closeCart      = $('closeCart');
const cartItemsEl    = $('cartItems');
const cartEmpty      = $('cartEmpty');
const cartFooter     = $('cartFooter');
const cartTotal      = $('cartTotal');
const btnDelivery    = $('btnDelivery');
const pickupFields   = null; // Removed
const sendOrderBtn   = $('sendOrderBtn');
const clearFilters   = $('clearFilters');
const totalP1        = $('total-products');
const totalP2        = $('total-products-2');
const floatingCart   = $('floatingCart');
const floatingBadge  = $('floatingCartBadge');
const floatingTotal  = $('floatingCartTotal');

/* ── Init ─────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
    if (typeof productsData === 'undefined' || !productsData.length) {
        productsGrid.innerHTML = '<p style="color:red;grid-column:1/-1;text-align:center;">Error cargando datos.</p>';
        return;
    }

    const total = productsData.length;
    totalP1.textContent = total;
    totalP2.textContent = total + '+';

    buildCategoryList();
    bindEvents();
    renderCatalog();
});

/* ── Build sidebar categories ─────────────────────── */
function buildCategoryList() {
    // Count per category
    const counts = {};
    productsData.forEach(p => {
        counts[p.category] = (counts[p.category] || 0) + 1;
    });
    const allCats = Object.keys(counts).sort();

    // "Todos" already in HTML – update count
    const allLi = categoryList.querySelector('[data-category="ALL"]');
    if(allLi) allLi.querySelector('.cat-count').textContent = productsData.length;

    const mobileSelect = document.getElementById('mobileCatSelect');
    if (mobileSelect) {
        mobileSelect.innerHTML = `<option value="ALL">🏪 Todos los Productos (${productsData.length})</option>`;
    }

    allCats.forEach(cat => {
        const emoji = CAT_EMOJI[cat] || '📦';
        const catName = cat.charAt(0)+cat.slice(1).toLowerCase();
        
        // Desktop List
        const li = document.createElement('li');
        li.className = 'cat-item';
        li.dataset.category = cat;
        li.innerHTML = `<span class="cat-emoji">${emoji}</span>${catName} <span class="cat-count">${counts[cat]}</span>`;
        categoryList.appendChild(li);

        // Mobile Select
        if (mobileSelect) {
            mobileSelect.innerHTML += `<option value="${cat}">${emoji} ${catName} (${counts[cat]})</option>`;
        }
    });
}

/* ── Events ───────────────────────────────────────── */
function bindEvents() {
    // Search
    searchInput.addEventListener('input', e => {
        state.search = e.target.value.toLowerCase().trim();
        clearSearch.classList.toggle('hidden', !state.search);
        renderCatalog();
    });

    clearSearch.addEventListener('click', () => {
        searchInput.value = '';
        state.search = '';
        clearSearch.classList.add('hidden');
        renderCatalog();
    });

    // Sort
    sortSelect.addEventListener('change', e => {
        state.sort = e.target.value;
        renderCatalog();
    });

    // Category sidebar (Desktop)
    categoryList.addEventListener('click', e => {
        const li = e.target.closest('.cat-item');
        if (!li) return;
        state.category = li.dataset.category;
        categoryList.querySelectorAll('.cat-item').forEach(el => el.classList.remove('active'));
        li.classList.add('active');
        
        // Sync mobile select
        const mobileSelect = document.getElementById('mobileCatSelect');
        if (mobileSelect) mobileSelect.value = state.category;
        
        renderCatalog();
    });

    // Category select (Mobile)
    const mobileSelect = document.getElementById('mobileCatSelect');
    if (mobileSelect) {
        mobileSelect.addEventListener('change', e => {
            state.category = e.target.value;
            // Sync desktop list
            categoryList.querySelectorAll('.cat-item').forEach(el => el.classList.remove('active'));
            const li = categoryList.querySelector(`[data-category="${state.category}"]`);
            if (li) li.classList.add('active');
            
            renderCatalog();
        });
    }

    // No results clear
    if (clearFilters) clearFilters.addEventListener('click', () => {
        state.search = '';
        state.category = 'ALL';
        searchInput.value = '';
        clearSearch.classList.add('hidden');
        categoryList.querySelectorAll('.cat-item').forEach(el => el.classList.remove('active'));
        categoryList.querySelector('[data-category="ALL"]').classList.add('active');
        if (mobileSelect) mobileSelect.value = 'ALL';
        renderCatalog();
    });

    // Cart panel
    cartBtn.addEventListener('click', openCart);
    closeCart.addEventListener('click', closeCartPanel);
    cartOverlay.addEventListener('click', closeCartPanel);

    // Removed delivery/pickup toggles

    // Send order
    sendOrderBtn.addEventListener('click', sendOrder);

    // Delegated click on products grid — ONE listener for the lifetime of the page
    productsGrid.addEventListener('click', onGridClick);

    // Delegated click on cart items — ONE listener
    cartItemsEl.addEventListener('click', onCartItemClick);

    // Floating cart bar — opens cart panel
    floatingCart.addEventListener('click', openCart);
}

/* ── Render Catalog ───────────────────────────────── */
function renderCatalog() {
    let list = productsData.filter(p => {
        const matchCat = state.category === 'ALL' || p.category === state.category;
        const matchSearch = !state.search ||
            p.name.toLowerCase().includes(state.search) ||
            p.id.toLowerCase().includes(state.search) ||
            p.brand.toLowerCase().includes(state.search);
        return matchCat && matchSearch;
    });

    // Sort
    if (state.sort === 'price-asc')  list.sort((a,b) => a.price - b.price);
    if (state.sort === 'price-desc') list.sort((a,b) => b.price - a.price);
    if (state.sort === 'name-asc')   list.sort((a,b) => a.name.localeCompare(b.name));

    resultsInfo.textContent = list.length === productsData.length
        ? `Mostrando todos los productos (${list.length})`
        : `${list.length} resultado${list.length !== 1 ? 's' : ''} encontrado${list.length !== 1 ? 's' : ''}`;

    if (list.length === 0) {
        productsGrid.innerHTML = '';
        noResults.classList.remove('hidden');
        return;
    }

    noResults.classList.add('hidden');

    const frag = document.createDocumentFragment();
    list.forEach(p => {
        const key = cartKey(p);
        const inCart = state.cart[key] ? state.cart[key].qty : 0;
        const card = document.createElement('article');
        card.className = 'product-card';
        card.dataset.id = p.id;
        card.dataset.brand = p.brand;

        // Fallback image by category
        const imgSrc = p.image || `images/generic.jpg`;

        card.innerHTML = `
            <div class="card-img-wrap">
                <span class="cat-chip">${(CAT_EMOJI[p.category]||'📦')} ${p.category}</span>
                <img src="${imgSrc}"
                     alt="${p.name}"
                     loading="lazy"
                     onerror="this.onerror=null; this.src='https://placehold.co/300x240/f0f4f8/94a3b8?text=${encodeURIComponent(p.category)}'">
            </div>
            <div class="card-body">
                <span class="card-brand">${p.brand || 'Genérico'}</span>
                <h3 class="card-name">${p.name}</h3>
                <span class="card-code">Ref: ${p.id}</span>
                <div class="card-footer">
                    <span class="card-price">Consultar</span>
                    <button class="btn-add-cart ${inCart > 0 ? 'added' : ''}" data-id="${p.id}" data-brand="${p.brand}">
                        ${inCart > 0 ? `✓ (${inCart})` : 'Consultar precio'}
                    </button>
                </div>
            </div>
        `;
        frag.appendChild(card);
    });

    productsGrid.innerHTML = '';
    productsGrid.appendChild(frag);
    // Single delegated click handler — set once on the static container, not re-added every render
}

function onGridClick(e) {
    const btn = e.target.closest('.btn-add-cart');
    if (!btn) return;
    const id = btn.dataset.id;
    const brand = btn.dataset.brand;
    addToCart(id, brand);
    // Visual feedback
    btn.classList.add('added');
    const key = `${id}|${brand}`;
    const qty = state.cart[key]?.qty || 0;
    btn.textContent = `✓ (${qty})`;
}

/* ── Cart Logic ───────────────────────────────────── */
function addToCart(id, brand) {
    const product = productsData.find(p => p.id === id && p.brand === brand);
    if (!product) return;
    const key = cartKey(product);
    if (state.cart[key]) {
        state.cart[key].qty++;
    } else {
        state.cart[key] = { product, qty: 1 };
    }
    updateCartUI();
    bumpFloatingCart(); // Urban Food bounce effect
}

function removeFromCart(key) {
    if (!state.cart[key]) return;
    if (state.cart[key].qty > 1) {
        state.cart[key].qty--;
    } else {
        delete state.cart[key];
    }
    updateCartUI();
    renderCatalog();
}

function deleteFromCart(key) {
    delete state.cart[key];
    updateCartUI();
    renderCatalog();
}

function updateCartUI() {
    const items = Object.values(state.cart);
    const totalQty = items.reduce((s, i) => s + i.qty, 0);

    // Badge
    if (totalQty > 0) {
        cartCount.textContent = totalQty;
        cartCount.classList.remove('hidden');
    } else {
        cartCount.classList.add('hidden');
    }

    // Total
    cartTotal.textContent = `A consultar`;

    // Floating cart bar update
    updateFloatingCart(totalQty);

    // Cart items panel
    renderCartItems(items, totalQty);
}

function updateFloatingCart(totalQty) {
    if (totalQty > 0) {
        floatingBadge.textContent = totalQty;
        floatingTotal.textContent = `Ver lista`;
        floatingCart.classList.add('visible');
    } else {
        floatingCart.classList.remove('visible');
    }
}

function bumpFloatingCart() {
    floatingCart.classList.remove('bump');
    // Force reflow so animation restarts
    void floatingCart.offsetWidth;
    floatingCart.classList.add('bump');
    // Clean up class after animation
    floatingCart.addEventListener('animationend', () => floatingCart.classList.remove('bump'), { once: true });
}

function renderCartItems(items, totalQty) {
    cartItemsEl.innerHTML = '';

    if (totalQty === 0) {
        cartItemsEl.appendChild(cartEmpty);
        cartEmpty.classList.remove('hidden');
        return;
    }

    cartEmpty.classList.add('hidden');

    items.forEach(({ product: p, qty }) => {
        const key = cartKey(p);
        const row = document.createElement('div');
        row.className = 'cart-row';
        row.innerHTML = `
            <img class="cart-row-img" src="${p.image || 'images/generic.jpg'}"
                 alt="${p.name}"
                 onerror="this.onerror=null;this.src='https://placehold.co/80x80/f0f4f8/94a3b8?text=IMG'">
            <div class="cart-row-info">
                <div class="cart-row-name">${p.name}</div>
                <div class="cart-row-brand" style="font-size:.75rem;color:var(--text-muted);">${p.brand}</div>
                <div class="cart-row-price">A consultar</div>
            </div>
            <div class="qty-controls">
                <button class="qty-btn remove-btn" data-action="remove" data-key="${key}">−</button>
                <span class="qty-val">${qty}</span>
                <button class="qty-btn" data-action="add" data-id="${p.id}" data-brand="${p.brand}">+</button>
                <button class="qty-btn remove-btn" data-action="delete" data-key="${key}" title="Eliminar">🗑</button>
            </div>
        `;
        cartItemsEl.appendChild(row);
    });
    // NOTE: cartItemsEl click is delegated once in bindEvents() — do NOT add here
}

function onCartItemClick(e) {
    const btn = e.target.closest('[data-action]');
    if (!btn) return;
    const { action, id, brand, key } = btn.dataset;
    if (action === 'add')    addToCart(id, brand);
    if (action === 'remove') removeFromCart(key);
    if (action === 'delete') deleteFromCart(key);
}

/* ── Cart Panel Toggle ────────────────────────────── */
function openCart() {
    cartPanel.classList.add('open');
    cartOverlay.classList.remove('hidden');
    document.body.style.overflow = 'hidden';
    updateCartUI();
}

function closeCartPanel() {
    cartPanel.classList.remove('open');
    cartOverlay.classList.add('hidden');
    document.body.style.overflow = '';
}

/* ── Delivery / Pickup mode ───────────────────────── */
function setMode(mode) {
    // Mode toggle removed
}

/* ── Send Order via WhatsApp ─────────────────────── */
function sendOrder() {
    const items = Object.values(state.cart);
    if (items.length === 0) {
        alert('Tu lista de consulta está vacía. Agrega al menos un producto.');
        return;
    }

    const name = ($('customerName').value || '').trim();
    if (!name) { 
        $('customerName').focus(); 
        alert('Por favor ingresa tu nombre para procesar la consulta.'); 
        return; 
    }

    let msg = `*📋 Consulta de Precios — Repuestos CR*\n`;
    msg += `─────────────────────\n`;
    msg += `*Cliente:* ${name}\n`;
    msg += `─────────────────────\n`;
    msg += `*PRODUCTOS A CONSULTAR:*\n`;
    
    items.forEach(({ product: p, qty }) => {
        // Solo Nombre y Marca, sin Referencia
        msg += `• (${qty}x) ${p.name.toUpperCase()} [${p.brand.toUpperCase()}]\n`;
    });
    
    msg += `─────────────────────\n`;
    msg += `\nHola, me gustaría consultar el precio y disponibilidad de estos repuestos. ¡Gracias! 🙏`;

    const url = `https://wa.me/${WHATSAPP_NUMBER}?text=${encodeURIComponent(msg)}`;
    window.open(url, '_blank');
}

/* ── Helpers ──────────────────────────────────────── */
function formatPrice(price) {
    return 'Consultar';
}
