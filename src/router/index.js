import { createRouter, createWebHistory } from 'vue-router'
import DashViewView from '../views/DashView.vue'
import PayRollView from '@/views/PayRollView.vue'
import PerformanceReviews from '@/views/PerformanceReviews.vue'
import TimeOff from '@/views/TimeOff.vue'
import RequestForm from '@/views/RequestForm.vue'
import EmployeeDirectory from '@/views/EmployeeDirectory.vue'
import Login from '@/views/Login.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: DashViewView
  },
  {
    path: '/payroll',
    name: 'payroll',
    component: PayRollView
  },
  {
    path: '/requestform',
    name: 'requestform',
    component: RequestForm
  },
  {
    path: '/timeoff',
    name: 'timeoff',
    component: TimeOff
  },
  {
    path: '/employeedirectory',
    name: 'employeedirectory',
    component: EmployeeDirectory
  },
  {
    path: '/performancereview',
    name: 'performancereview',
    component: PerformanceReviews
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

// Navigation guard to protect routes
router.beforeEach((to, from, next) => {
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
  if (to.name !== 'Login' && !isLoggedIn) {
    next({ name: 'Login' });
  } else if (to.name === 'Login' && isLoggedIn) {
    next({ name: 'Dashboard' });
  } else {
    next();
  }
});

export default router
