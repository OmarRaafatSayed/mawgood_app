const express = require("express");
const axios = require("axios");
const path = require("path");
require("dotenv").config({path : path.join(__dirname, '..' , 'config.env')});

const app = express();
const PORT = process.env.PORT || 3000;
const MEDUSA_URL = "http://localhost:9000";

app.use(express.json());

// Auth Routes
app.post("/api/signup", async (req, res) => {
  try {
    const response = await axios.post(`${MEDUSA_URL}/store/customers`, {
      email: req.body.email,
      password: req.body.password,
      first_name: req.body.name?.split(' ')[0] || '',
      last_name: req.body.name?.split(' ')[1] || '',
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.post("/api/signin", async (req, res) => {
  try {
    const response = await axios.post(`${MEDUSA_URL}/store/auth`, {
      email: req.body.email,
      password: req.body.password,
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.post("/IsTokenValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    
    const response = await axios.get(`${MEDUSA_URL}/store/customers/me`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(true);
  } catch (error) {
    res.json(false);
  }
});

app.get("/", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const response = await axios.get(`${MEDUSA_URL}/store/customers/me`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

// Product Routes
app.get("/api/products", async (req, res) => {
  try {
    const category = req.query.category;
    let url = `${MEDUSA_URL}/store/products`;
    if (category) {
      url += `?category_id[]=${category}`;
    }
    const response = await axios.get(url);
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/api/products/search", async (req, res) => {
  try {
    const name = req.query.name;
    const response = await axios.get(`${MEDUSA_URL}/store/products?q=${name}`);
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/api/deal-of-the-day", async (req, res) => {
  try {
    const response = await axios.get(`${MEDUSA_URL}/store/products?limit=1`);
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

// Cart Routes
app.post("/api/add-to-cart", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const { id, quantity } = req.body;
    
    // Get or create cart
    let cartId = req.body.cartId;
    if (!cartId) {
      const cartResponse = await axios.post(`${MEDUSA_URL}/store/carts`);
      cartId = cartResponse.data.cart.id;
    }
    
    const response = await axios.post(`${MEDUSA_URL}/store/carts/${cartId}/line-items`, {
      variant_id: id,
      quantity: quantity || 1
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/api/get-cart", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const cartId = req.query.cartId;
    
    if (!cartId) {
      return res.json({ cart: { items: [] } });
    }
    
    const response = await axios.get(`${MEDUSA_URL}/store/carts/${cartId}`);
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.delete("/api/remove-from-cart/:id", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const cartId = req.body.cartId;
    const lineItemId = req.params.id;
    
    const response = await axios.delete(`${MEDUSA_URL}/store/carts/${cartId}/line-items/${lineItemId}`);
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

// Order Routes
app.post("/api/order", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const cartId = req.body.cartId;
    
    const response = await axios.post(`${MEDUSA_URL}/store/carts/${cartId}/complete`);
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/api/orders/me", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const response = await axios.get(`${MEDUSA_URL}/store/customers/me/orders`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

// Admin Routes
app.post("/admin/add-product", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const response = await axios.post(`${MEDUSA_URL}/admin/products`, req.body, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/admin/get-category-product", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const category = req.query.category;
    const response = await axios.get(`${MEDUSA_URL}/admin/products?category_id[]=${category}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.delete("/admin/delete-product", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const productId = req.body.id;
    const response = await axios.delete(`${MEDUSA_URL}/admin/products/${productId}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/admin/get-orders", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const response = await axios.get(`${MEDUSA_URL}/admin/orders`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.post("/admin/change-order-status", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const { id, status } = req.body;
    const response = await axios.post(`${MEDUSA_URL}/admin/orders/${id}`, 
      { status },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.get("/admin/analytics", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    const response = await axios.get(`${MEDUSA_URL}/admin/orders`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    
    // Calculate analytics from orders
    const orders = response.data.orders || [];
    const totalEarnings = orders.reduce((sum, order) => sum + (order.total || 0), 0);
    
    res.json({
      totalEarnings,
      categoryEarnings: []
    });
  } catch (error) {
    res.status(error.response?.status || 500).json({ error: error.message });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Bridge Server running on port: ${PORT}`);
  console.log(`Connecting to Medusa at: ${MEDUSA_URL}`);
});

module.exports = app;
