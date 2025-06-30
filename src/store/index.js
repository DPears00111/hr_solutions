import { createStore } from 'vuex';

export default createStore({
  state: {
    leaveRequests: [],
    employees: []
  },
  getters: {
    getLeaveRequests: state => state.leaveRequests,
    getEmployees: state => state.employees,
    employeeCount: state => state.employees.length
  },
  mutations: {
    setLeaveRequests(state, requests) {
      state.leaveRequests = requests;
    },
    addLeaveRequest(state, request) {
      request.status ='Pending'
      state.leaveRequests.push(request);
      localStorage.setItem('leaveRequests', JSON.stringify(state.leaveRequests));
    },
    setEmployees(state, employees) {
      state.employees = employees;
    },
    addEmployees(state, employee) {
      state.employees.push(employee);
      localStorage.setItem('employees', JSON.stringify(state.employees));
    },
    updateLeaveRequestStatus(state, { id, status }) {
      const req = state.leaveRequests.find(r => r.id === id);
      if (req) {
        req.status = status;
        localStorage.setItem('leaveRequests', JSON.stringify(state.leaveRequests));
      }
    }
  },
  actions: {
    loadLeaveRequests({ commit }) {
      const saved = localStorage.getItem('leaveRequests');
      if (saved) {
        commit('setLeaveRequests', JSON.parse(saved));
      }
    },
    addLeaveRequest({ commit }, request) {
      commit('addLeaveRequest', request);
    },
    loadEmployees({ commit }) {
      const saved = localStorage.getItem('employees');
      if (saved) {
        commit('setEmployees', JSON.parse(saved));
      }
    },
    addEmployee({ commit }, employee) {
      commit('addEmployee', employee);
    }
  }
});
