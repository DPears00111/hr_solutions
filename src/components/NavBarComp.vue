<template>
    <div :class="['sidebar', { collapsed }]">
        <button class="collapse-btn" @click="$emit('toggle')">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="sidebar-inner p-3 text-bg-dark" >
            <router-link
                to="/"
                class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none"
            >
                <svg class="bi pe-none me-2" width="40" height="32" aria-hidden="true">
                    <use xlink:href="#bootstrap"></use>
                </svg>
                <span v-if="!collapsed" class="fs-4">HR SOLUTIONS</span>
            </router-link>
            <hr>
            <ul class="nav nav-pills flex-column mb-auto">
                <li class="nav-item">
                    <router-link to="/dashboard" class="nav-link text-white" exact-active-class="router-link-exact-active">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#home"></use>
                        </svg>
                        <span v-if="!collapsed"> <i class="fa-solid fa-table-columns"></i> Dashboard </span> 
                    </router-link>
                </li>
                <li>
                    <router-link to="/payroll" class="nav-link text-white">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#speedometer2"></use>
                        </svg>
                        <span v-if="!collapsed"><i class="fa-solid fa-file-invoice-dollar"></i> Payroll </span>
                    </router-link>
                </li>
                <li>
                    <router-link to="/performancereview" class="nav-link text-white">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#table"></use>
                        </svg>
                        <span v-if="!collapsed"><i class="fa-solid fa-chart-line"></i> Performance Review </span>
                    </router-link>
                </li>
                <li>
                    <router-link to="/timeoff" class="nav-link text-white">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#table"></use>
                        </svg>
                        <span v-if="!collapsed"><i class="fa-solid fa-business-time"></i> Time-Off </span>
                    </router-link>
                </li>
                <li>
                    <router-link to="/requestform" class="nav-link text-white">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#table"></use>
                        </svg>
                        <span v-if="!collapsed"><i class="fa-regular fa-rectangle-list"></i> Leave Request form </span>
                    </router-link>
                </li>
                <li>
                    <router-link to="/employeedirectory" class="nav-link text-white">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#table"></use>
                        </svg>
                        <span v-if="!collapsed"><i class="fa-solid fa-users"></i> Employees </span>
                    </router-link>
                </li>
            </ul>
            <div class="dropdown mt-auto"> 
                <a href="#"
                    class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                    data-bs-toggle="dropdown" aria-expanded="false"> <img src="https://github.com/mdo.png" alt=""
                        width="32" height="32" class="rounded-circle me-2"> <strong v-if="!collapsed">HR USER</strong> </a>
                <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
                    <li><a class="dropdown-item" href="#">Settings</a></li>
                    <li><a class="dropdown-item" href="#">Profile</a></li>
                    <li>
                        <hr class="dropdown-divider">
                    </li>
                    <li><a class="dropdown-item" href="#" @click.prevent="signOut">Sign out</a></li>
                </ul>
            </div>
        </div>
    </div>
</template>
<script>
export default {
    props: {
        collapsed: {
            type: Boolean,
            default: false
        }
    },
    methods: {
        signOut() {
            localStorage.removeItem('isLoggedIn');
            this.$router.push({ name: 'Login' });
        }
    }
}
</script>
<style>
.nav-link.router-link-exact-active {
    background-color: #0d6efd; 
    color: #fff !important;
}
.sidebar.collapsed .nav-link.router-link-exact-active {
    background-color: transparent;
    color: #fff !important;
}
.sidebar {
    width: 280px;
    flex-shrink: 0;
    background-color: #212529;
    transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow-x: hidden;
    height: 100vh; /* Add this line */
    position: fixed; /* Optional: keeps sidebar fixed on scroll */
    top: 0;
    left: 0;
    z-index: 100;
}
.sidebar.collapsed {
    width: 60px;
}
.collapse-btn {
    position: absolute;
    top: 10px;
    left: 10px;
    background: transparent;
    color: #fff;
    border: none;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    cursor: pointer;
    outline: none;
    box-shadow: none;
}
.sidebar-inner {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
}
.dropdown {
    margin-top: auto;
}
</style>