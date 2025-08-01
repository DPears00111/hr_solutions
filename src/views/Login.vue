<template>
  <div class="login-page">
    <div class="login-box">
      <div class="login-heading">
        <h2><img src="https://static.vecteezy.com/system/resources/previews/037/359/313/non_2x/hr-blue-logo-design-logo-design-for-business-free-vector.jpg" alt="logo" class="logo"/> Login</h2>
      </div>
      <form @submit.prevent="login">
        <div class="form-group">
          <label for="username">Username</label>
          <input
            id="username"
            v-model="username"
            type="text"
            placeholder="Enter your username"
            required
          />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input
            id="password"
            v-model="password"
            type="password"
            placeholder="Enter your password"
            required
          />
        </div>
        <!-- <div class="form-group">
          <label for="role">Login as:</label>
          <select id="role" v-model="role" class="role-select">
            <option value="admin">Admin</option>
            <option value="employee">Employee</option>
          </select>
        </div> -->
        <button type="submit" class="login-btn">Login</button>
        <p v-if="error" class="error">{{ error }}</p>
      </form>
      
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      username: '',
      password: '',
      role: 'admin',
      error: ''
    };
  },
  mounted() {
    const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    const role = localStorage.getItem('userRole');
    const expiry = parseInt(localStorage.getItem('sessionExpiry'), 10);
    const now = new Date().getTime();
    if (isLoggedIn && role === 'employee' && now > expiry) {
      localStorage.clear();
      alert('Session expired. Please log in again.');
      this.$router.push('/login');
    }
  },
  methods: {
    login() {
      const currentTime = new Date().getTime();
      // Admin login
      if (
        this.role === 'admin' &&
        this.username === 'admin' &&
        this.password === 'admin123'
      ) {
        localStorage.setItem('isLoggedIn', 'true');
        localStorage.setItem('userRole', 'admin');
        localStorage.removeItem('sessionExpiry');
        this.$router.push('/dashboard');  // Admin dashboard route
      }
      // Invalid credentials
      else {
        this.error = 'Invalid username or password';
      }
    },
   
  }
};
</script>
<style scoped>
.login-page {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  flex-grow: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: url('https://cdn.pixabay.com/photo/2023/03/25/10/39/wave-7875632_1280.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  min-height: 100vh;
  min-width: 100vw;
  overflow: hidden;
  z-index: 1000;
}
body, html {
  overflow: hidden;
}
.login-box {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(12px);
  padding: 2rem;
  border-radius: 12px;
  width: 100%;
  max-width: 400px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
  color: black;
}
.login-heading{
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  font-size: 1.8rem;
  margin-bottom: 1.5rem;
}

.logo{
  width: 60px;
  height: 60px;
  border-radius: 50%;
  object-fit: cover;
}
.form-group {
  margin-bottom: 1.2rem;
}
h2 {
  text-align: center;
  margin-bottom: 1.5rem;
}
.form-group {
  margin-bottom: 1.2rem;
}
label {
  display: block;
  font-weight: 500;
  margin-bottom: 0.5rem;
}
input, .role-select {
  width: 100%;
  padding: 0.6rem;
  border: 1px solid #ccc;
  border-radius: 5px;
  font-size: 1rem;
}
/* Animated gradient border on button */
.login-btn {
  position: relative;
  width: 100%;
  padding: 0.75rem;
  background-color: #0D6EFD;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  cursor: pointer;
  z-index: 1;
  overflow: hidden;
  margin-top: 0.5rem;
}
.login-btn::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: linear-gradient(45deg, #6A0DAD, #0F0F3D, #004953, #6A0DAD
);

  background-size: 400% 400%;
  border-radius: 10px;
  z-index: -1;
  animation: button-glow 6s ease infinite;
}
@keyframes button-glow {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.error {
  color: red;
  margin-top: 0.75rem;
  text-align: center;
}

</style>