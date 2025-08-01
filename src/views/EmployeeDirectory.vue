<template>
  <div class="employee-directory container-fluid px-2 px-md-4">
    <div class="header row align-items-center mb-3">
      <div class="col-12 col-md-6 mb-2 mb-md-0">
        <h1 class="h3 h1-responsive">Employee Directory</h1>
      </div>
      <div class="col-12 col-md-6 header-actions d-flex justify-content-md-end">
        <input 
          type="text" 
          class="form-control w-100 w-md-auto" 
          placeholder="Search by name, position, or department" 
          v-model="searchQuery"
        >
      </div>
      <div class="add">
        <div class="btn btn-primary" @click="showAddModal = true">Add Employee</div>
      </div>
    <!-- Add Employee Modal -->
    <div 
      class="modal fade" 
      :class="{ 'show': showAddModal }" 
      tabindex="-1" 
      role="dialog" 
      style="display: block;" 
      v-if="showAddModal"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title">Add Employee</h5>
            <button 
              type="button" 
              class="close text-white" 
              @click="closeAddModal" 
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitAdd">
              <div class="row">
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Name</label>
                  <input v-model="addForm.name" type="text" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Position</label>
                  <input v-model="addForm.position" type="text" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Department</label>
                  <input v-model="addForm.department" type="text" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Contact</label>
                  <input v-model="addForm.contact" type="text" class="form-control" required />
                </div>
                <div class="col-12 mb-3">
                  <label class="form-label">Employment History</label>
                  <textarea v-model="addForm.employment_history" class="form-control" rows="2"></textarea>
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Salary</label>
                  <input v-model="addForm.salary" type="number" min="0" step="0.01" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Deductions</label>
                  <input v-model="addForm.deductions" type="number" min="0" step="0.01" class="form-control" required />
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeAddModal">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Employee</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="mt-2">Loading employee data...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      Error loading employees: {{ error }}
      <button @click="fetchEmployees" class="btn btn-sm btn-outline-danger ms-2">Retry</button>
    </div>

    <!-- Success State -->
    <div v-else class="row">
      <div class="col-12">
        <div class="card mb-4">
          <div class="card-header bg-primary text-white">
            <h3 class="h5 mb-0">Employees</h3>
          </div>
          <div class="card-body p-2 p-md-4">
            <div class="table-responsive">
              <table class="table table-hover align-middle">
                <thead class="table-light">
                  <tr>
                    <th>Employee</th>
                    <th>Position</th>
                    <th>Department</th>
                    <th>Employment History</th>
                    <th>Contact</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr 
                    v-for="employee in filteredEmployees" 
                    :key="employee.id" 
                    @click="showEmployeeModal(employee)"
                  >
                    <td>{{ employee.name }}</td>
                    <td>{{ employee.position }}</td>
                    <td>{{ employee.department }}</td>
                    <td class="text-break">{{ employee.employment_history }}</td>
                    <td class="text-break">{{ employee.contact }}</td>
                    <td>
                      <button class="btn btn-sm btn-outline-primary" @click.stop="editEmployee(employee)">Edit</button>
                      <button class="btn btn-sm btn-outline-danger" @click.stop="deleteEmployee(employee.id)">Delete</button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Employee Edit Modal -->
    <div 
      class="modal fade" 
      :class="{ 'show': showEditModal }" 
      tabindex="-1" 
      role="dialog" 
      style="display: block;" 
      v-if="showEditModal"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title">Edit Employee</h5>
            <button 
              type="button" 
              class="close text-white" 
              @click="closeEditModal" 
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitEdit">
              <div class="row">
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Name</label>
                  <input v-model="editForm.name" type="text" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Position</label>
                  <input v-model="editForm.position" type="text" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Department</label>
                  <input v-model="editForm.department" type="text" class="form-control" required />
                </div>
                <div class="col-12 col-md-6 mb-3">
                  <label class="form-label">Contact</label>
                  <input v-model="editForm.contact" type="text" class="form-control" required />
                </div>
                <div class="col-12 mb-3">
                  <label class="form-label">Employment History</label>
                  <textarea v-model="editForm.employment_history" class="form-control" rows="2"></textarea>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeEditModal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <!-- Employee Details Modal -->
    <div 
      class="modal fade" 
      :class="{ 'show': showModal }" 
      tabindex="-1" 
      role="dialog" 
      style="display: block;" 
      v-if="showModal"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title">Employee Details</h5>
            <button 
              type="button" 
              class="close text-white" 
              @click="closeModal" 
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-12 col-md-4 mb-3 mb-md-0 d-flex justify-content-center align-items-center">
                <div class="employee-photo-placeholder mx-auto">
                  <span class="initials">{{ getInitials(selectedEmployee.name) }}</span>
                </div>
              </div>
              <div class="col-12 col-md-8">
                <h3 class="h5">{{ selectedEmployee.name }}</h3>
                <p class="text-muted mb-2">{{ selectedEmployee.position }}</p>
                <hr>
                <div class="row">
                  <div class="col-12 col-sm-6">
                    <p><strong>Employee ID:</strong> {{ selectedEmployee.id }}</p>
                    <p><strong>Department:</strong> {{ selectedEmployee.department }}</p>
                  </div>
                  <div class="col-12 col-sm-6">
                    <p><strong>Contact:</strong> {{ selectedEmployee.contact }}</p>
                    <p><strong>Employment History:</strong></p>
                    <p class="text-break">{{ selectedEmployee.employment_history }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeModal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      employees: [],
      searchQuery: '',
      showModal: false,
      showEditModal: false,
      showAddModal: false,
      selectedEmployee: null,
      editForm: {
        id: null,
        name: '',
        position: '',
        department: '',
        contact: '',
        employment_history: ''
      },
      isLoading: false,
      error: null,
      addForm: {
        name: '',
        position: '',
        department: '',
        contact: '',
        employment_history: '',
        salary: '',
        deductions: ''
      }
    };
  },
  computed: {
    filteredEmployees() {
      const query = this.searchQuery.toLowerCase();
      if (!query) {
        return this.employees;
      }
      return this.employees.filter(emp => {
        return (
          emp.name.toLowerCase().includes(query) ||
          emp.position.toLowerCase().includes(query) ||
          emp.department.toLowerCase().includes(query) ||
          emp.contact.toLowerCase().includes(query) ||
          (emp.employment_history && emp.employment_history.toLowerCase().includes(query))
        );
      });
    }
  },
  methods: {
    closeAddModal() {
      this.showAddModal = false;
      this.resetAddForm();
      document.body.classList.remove('modal-open');
    },
    resetAddForm() {
      this.addForm = {
        name: '',
        position: '',
        department: '',
        contact: '',
        employment_history: ''
      };
    },
    async submitAdd() {
      try {
        // 1. Create employee
        const empRes = await axios.post(`${process.env.VUE_APP_API_BASE_URL}/employee`, {
          name: this.addForm.name,
          position: this.addForm.position,
          department: this.addForm.department,
          contact: this.addForm.contact,
          employment_history: this.addForm.employment_history
        });
        const employeeId = empRes.data.id;
        // 2. Create payroll for this employee
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/payroll`, {
          employeeId: employeeId,
          base_salary: this.addForm.salary, // use base_salary key
          deductions: this.addForm.deductions,
          pay_period_start: new Date().toISOString().slice(0,10),
          pay_period_end: new Date().toISOString().slice(0,10),
          hours_worked: 0,
          net_pay: (parseFloat(this.addForm.salary) - parseFloat(this.addForm.deductions)),
          created_at: new Date().toISOString().slice(0,19).replace('T',' '),
          updated_at: new Date().toISOString().slice(0,19).replace('T',' ')
        });
        this.closeAddModal();
        await this.fetchEmployees();
      } catch (error) {
        alert('Failed to add employee and payroll.');
        console.error(error);
      }
    },
    async fetchEmployees() {
      this.isLoading = true;
      this.error = null;
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/employee`);
        this.employees = response.data;
      } catch (error) {
        this.error = error.response?.data?.message || error.message;
        console.error('Error fetching employees:', error);
      } finally {
        this.isLoading = false;
      }
    },
    showEmployeeModal(employee) {
      this.selectedEmployee = employee;
      this.showModal = true;
      document.body.classList.add('modal-open');
    },
    closeModal() {
      this.showModal = false;
      document.body.classList.remove('modal-open');
    },
    showEditModalFn(employee) {
      this.editForm = {
        id: employee.id,
        name: employee.name,
        position: employee.position,
        department: employee.department,
        contact: employee.contact,
        employment_history: employee.employment_history,
        
      };
      this.showEditModal = true;
      document.body.classList.add('modal-open');
    },
    closeEditModal() {
      this.showEditModal = false;
      document.body.classList.remove('modal-open');
    },
    async submitEdit() {
      try {
        const employeeInfo = {
          name: this.editForm.name,
          position: this.editForm.position,
          department: this.editForm.department,
          employment_history: this.editForm.employment_history,
          contact: this.editForm.contact
        };
        await axios.put(`${process.env.VUE_APP_API_BASE_URL}/employee/${this.editForm.id}`, employeeInfo);
        this.closeEditModal();
        await this.fetchEmployees();
      } catch (error) {
        alert('Failed to update employee.');
        console.error(error);
      }
    },
    async deleteEmployee(id) {
      if (!confirm('Are you sure you want to delete this employee?')) return;
      try {
        await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/employee/${id}`);
        this.employees = this.employees.filter(emp => emp.id !== id);
      } catch (error) {
        alert('Failed to delete employee.');
        console.error(error);
      }
    },
    editEmployee(employee) {
      this.showEditModalFn(employee);
    },
    getInitials(name) {
      return name.split(' ').map(n => n[0]).join('').toUpperCase();
    }
  },
  mounted() {
    this.fetchEmployees();
  }
};
</script>

<style scoped>
.employee-directory {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px 0;
}

.header {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.header-actions {
  min-width: 220px;
}

@media (max-width: 767.98px) {
  .header {
    flex-direction: column;
    align-items: stretch;
    gap: 10px;
  }
  
  .header-actions {
    width: 100%;
    margin-top: 10px;
  }
  
  .employee-directory {
    padding: 10px;
  }
  
  .modal-content {
    padding: 0.5rem;
  }
}

input[type="text"] {
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 20px;
  min-width: 180px;
}

tr {
  cursor: pointer;
}

tr:hover {
  background-color: #f5f5f5;
}

.table {
  font-size: 1rem;
}

@media (max-width: 575.98px) {
  .table {
    font-size: 0.92rem;
  }
  
  .modal-content {
    font-size: 0.95rem;
  }
  
  .employee-photo-placeholder {
    width: 100px;
    height: 100px;
  }
  
  .initials {
    font-size: 32px;
  }
}

.employee-photo-placeholder {
  width: 150px;
  height: 150px;
  background-color: #007bff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
}

.initials {
  color: white;
  font-size: 48px;
  font-weight: bold;
}

.modal-backdrop {
  opacity: 0.5;
}
</style>