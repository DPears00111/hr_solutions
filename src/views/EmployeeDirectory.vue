<template>
  <div class="payroll-view container-fluid px-2 px-md-4">
    <div class="header row align-items-center mb-3">
      <div class="col-12 col-md-6 mb-2 mb-md-0">
        <h1 class="h3 h1-responsive">Employee Directory</h1>
      </div>
      <div class="col-12 col-md-6 header-actions d-flex justify-content-md-end">
        <input type="text" class="form-control w-100 w-md-auto" placeholder="Search by name, position, or department" v-model="searchQuery">
      </div>
    </div>
    <div class="row">
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
                    <th>Employee Position</th>
                    <th>Department</th>
                    <th>Employment History</th>
                    <th>Contact</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="emp in filteredEmployees" :key="emp.employeeId" @click="showEmployeeModal(emp)">
                    <td>{{ emp.name }}</td>
                    <td>{{ emp.position }}</td>
                    <td>{{ emp.department }}</td>
                    <td class="text-break">{{ emp.employmentHistory }}</td>
                    <td class="text-break">{{ emp.contact }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Employee Details Modal -->
    <div class="modal fade" :class="{ 'show': showModal }" tabindex="-1" role="dialog" style="display: block;" v-if="showModal">
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title">Employee Details</h5>
            <button type="button" class="close text-white" @click="closeModal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-12 col-md-4 mb-3 mb-md-0 d-flex justify-content-center align-items-center">
                <template v-if="selectedEmployee && selectedEmployee.name && getInitials(selectedEmployee.name)">
                  <div class="employee-photo-placeholder mx-auto">
                    <span class="initials">{{ getInitials(selectedEmployee.name) }}</span>
                  </div>
                </template>
              </div>
              <div class="col-12 col-md-8">
                <h3 class="h5">{{ selectedEmployee.name }}</h3>
                <p class="text-muted mb-2">{{ selectedEmployee.position }}</p>
                <hr>
                <div class="row">
                  <div class="col-12 col-sm-6">
                    <p><strong>Employee ID:</strong> {{ selectedEmployee.employeeId }}</p>
                    <p><strong>Department:</strong> {{ selectedEmployee.department }}</p>
                    <p><strong>Salary:</strong> R{{ selectedEmployee.salary.toLocaleString() }}</p>
                  </div>
                  <div class="col-12 col-sm-6">
                    <p><strong>Contact:</strong> {{ selectedEmployee.contact }}</p>
                    <p><strong>Employment History:</strong></p>
                    <p class="text-break">{{ selectedEmployee.employmentHistory }}</p>
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
import employeeData from '@/assets/employee_info.json'

export default {
  data() {
    return {
      employeeData: JSON.parse(JSON.stringify(employeeData)),
      searchQuery: '',
      showModal: false,
      selectedEmployee: null
    };
  },
  computed: {
    filteredEmployees() {
      const query = this.searchQuery.toLowerCase();
      if (!query) {
        return this.employeeData.employeeInformation;
      }
      return this.employeeData.employeeInformation.filter(emp => {
        return (
          emp.name.toLowerCase().includes(query) ||
          emp.position.toLowerCase().includes(query) ||
          emp.department.toLowerCase().includes(query) ||
          emp.contact.toLowerCase().includes(query) ||
          emp.employmentHistory.toLowerCase().includes(query)
        );
      });
    }
  },
  methods: {
    showEmployeeModal(employee) {
      this.selectedEmployee = employee;
      this.showModal = true;
      document.body.classList.add('modal-open');
    },
    closeModal() {
      this.showModal = false;
      document.body.classList.remove('modal-open');
    },
    getInitials(name) {
      return name.split(' ').map(n => n[0]).join('').toUpperCase();
    }
  }
}
</script>

<style scoped>
.payroll-view {
  max-width: 1200px;
  margin: 0 auto;
  padding: 10px 0 20px 0;
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
  .payroll-view {
    padding: 5px;
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
</style>