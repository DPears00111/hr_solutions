<template>
  <div class="app-layout">
    <NavBarComp v-if="$route.name !== 'Login'" :collapsed="sidebarCollapsed" @toggle="sidebarCollapsed = !sidebarCollapsed" />
    <div
      class="main-content"
      :class="{ collapsed: sidebarCollapsed }"
    >
      <router-view />
    </div>
  </div>
</template>

<script>
import NavBarComp from './components/NavBarComp.vue'
export default {
  components: { NavBarComp },
  data() {
    return {
      sidebarCollapsed: false
    }
  }
}
</script>

<style>
html, body, #app {
  height: 100%;
  margin: 0;
  padding: 0;
}

#app {
  font-family: Vanir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  display: flex;
  flex-direction: column;
}

.app-layout {
  display: flex;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  padding: 24px;
  overflow-y: auto;
  transition: margin-left 0.3s;
  margin-left: 280px; /* default sidebar width */
}

.main-content.collapsed {
  margin-left: 60px; /* collapsed sidebar width */
}
</style>