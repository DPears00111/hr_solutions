<template>
  <div class="timeoff-container">
    <div class="header">
      <h1>Time Off Management</h1>
      <div class="search-container">
        <input 
          type="text" 
          placeholder="Search employees..." 
          v-model="searchQuery"
          class="search-input"
        >
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="spinner-border text-primary" role="status"></div>
      <span>Loading data...</span>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="error-state">
      <div class="alert alert-danger">
        {{ error }}
        <button @click="fetchData" class="btn btn-sm btn-light ms-2">Retry</button>
      </div>
    </div>

    <!-- Main Content -->
    <div v-else>
      <!-- Employee Summary -->
      <div class="card summary-card mb-4">
        <div class="card-header bg-primary text-white">
          <h2>Employee Summary</h2>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-hover">
              <thead>
                <tr>
                  <th>Employee</th>
                  <th>Position</th>
                  <th>Department</th>
                  <th>Pending Requests</th>
                  <th>Approved Requests</th>
                  <th>Rejected Requests</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="employee in filteredEmployees" :key="employee.id">
                  <td>{{ employee.name }}</td>
                  <td>{{ employee.position }}</td>
                  <td>{{ employee.department }}</td>
                  <td>{{ getRequestCount(employee.id, 'pending') }}</td>
                  <td>{{ getRequestCount(employee.id, 'approved') }}</td>
                  <td>{{ getRequestCount(employee.id, 'rejected') }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Leave Requests Management -->
      <div class="card requests-card">
        <div class="card-header bg-info text-white">
          <h2>Leave Requests</h2>
        </div>
        <div class="card-body">
          <div class="row">
            <!-- Pending Requests -->
            <div class="col-md-6 pending-column">
              <h3>Pending Approval</h3>
              <div v-if="pendingRequests.length === 0" class="no-requests">
                No pending leave requests
              </div>
              <div v-else class="request-list">
                <div 
                  v-for="request in pendingRequests" 
                  :key="request.id"
                  class="request-item"
                >
                  <div class="request-header">
                    <div class="employee-info">
                      <strong>{{ request.employeeName }}</strong>
                      <span class="badge bg-warning text-dark">Pending</span>
                    </div>
                    <div class="request-dates">
                      {{ formatDate(request.startDate) }} to {{ formatDate(request.endDate) }}
                    </div>
                  </div>
                  <div class="request-body">

                    <p><strong>Reason:</strong> {{ request.reason }}</p>
                    <p v-if="request.isEmergency" class="text-danger">
                      <strong>Emergency Leave</strong>
                    </p>
                  </div>
                  <div class="request-actions">
                    <button 
                      class="btn btn-success btn-sm"
                      @click="updateRequestStatus(request.id, 'approved')"
                    >
                      Approve
                    </button>
                    <button 
                      class="btn btn-danger btn-sm"
                      @click="updateRequestStatus(request.id, 'rejected')"
                    >
                      Deny
                    </button>
                    <button 
                      class="btn btn-outline-secondary btn-sm ms-2"
                      @click="showRequestDetails(request)"
                    >
                      Details
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Processed Requests -->
            <div class="col-md-6 processed-column">
              <h3>Processed Requests</h3>
              <div v-if="processedRequests.length === 0" class="no-requests">
                No processed leave requests
              </div>
              <div v-else class="request-list">
                <div 
                  v-for="request in processedRequests" 
                  :key="request.id"
                  class="request-item"
                  :class="{
                    'request-approved': request.status === 'approved',
                    'request-rejected': request.status === 'rejected'
                  }"
                >
                  <div class="request-header">
                    <div class="employee-info">
                      <strong>{{ request.employeeName }}</strong>
                      <span 
                        class="badge"
                        :class="{
                          'bg-success': request.status === 'approved',
                          'bg-danger': request.status === 'rejected'
                        }"
                      >
                        {{ request.status }}
                      </span>
                    </div>
                    <div class="request-dates">
                      {{ formatDate(request.startDate) }} to {{ formatDate(request.endDate) }}
                    </div>
                  </div>
                  <div class="request-body">
                    <p><strong>Reason:</strong> {{ request.reason }}</p>
                  </div>
                  <div class="request-actions">
                    <button 
                      class="btn btn-outline-secondary btn-sm"
                      @click="showRequestDetails(request)"
                    >
                      Details
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Request Details Modal -->
    <div class="modal fade" id="requestDetailsModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Leave Request Details</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body" v-if="selectedRequest">
            <div class="row mb-3">
              <div class="col-4"><strong>Employee:</strong></div>
              <div class="col-8">{{ selectedRequest.employeeName }}</div>
            </div>
            <div class="row mb-3">
              <div class="col-4"><strong>Dates:</strong></div>
              <div class="col-8">
                {{ formatDate(selectedRequest.startDate) }} to {{ formatDate(selectedRequest.endDate) }}
                ({{ calculateDays(selectedRequest.startDate, selectedRequest.endDate) }} days)
              </div>
            </div>
            <div class="row mb-3">
              <div class="col-4"><strong>Type:</strong></div>
              <div class="col-8">{{ selectedRequest.leaveType || 'Not specified' }}</div>
            </div>
            <div class="row mb-3">
              <div class="col-4"><strong>Reason:</strong></div>
              <div class="col-8">{{ selectedRequest.reason }}</div>
            </div>
            <div class="row mb-3" v-if="selectedRequest.isEmergency">
              <div class="col-4"><strong>Emergency:</strong></div>
              <div class="col-8 text-danger">Yes</div>
            </div>
            <div class="row mb-3">
              <div class="col-4"><strong>Status:</strong></div>
              <div class="col-8">
                <span 
                  class="badge"
                  :class="{
                    'bg-warning': selectedRequest.status === 'pending',
                    'bg-success': selectedRequest.status === 'approved',
                    'bg-danger': selectedRequest.status === 'rejected'
                  }"
                >
                  {{ selectedRequest.status }}
                </span>
              </div>
            </div>
            <div class="row mb-3" v-if="selectedRequest.status !== 'pending'">
              <div class="col-4"><strong>Processed:</strong></div>
              <div class="col-8">{{ formatDate(selectedRequest.updatedAt) }}</div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { Modal } from 'bootstrap';

export default {
  name: 'TimeOff',
  data() {
    return {
      searchQuery: '',
      employees: [],
      timeOffRequests: [],
      loading: true,
      error: null,
      selectedRequest: null,
      detailsModal: null
    };
  },
  computed: {
    filteredEmployees() {
      const query = this.searchQuery.toLowerCase();
      if (!query) return this.employees;
      
      return this.employees.filter(emp => 
        emp.name.toLowerCase().includes(query) ||
        emp.position.toLowerCase().includes(query) ||
        emp.department.toLowerCase().includes(query)
      );
    },
    pendingRequests() {
      return this.timeOffRequests
        .filter(req => req.status === 'pending')
        .sort((a, b) => new Date(a.startDate) - new Date(b.startDate));
    },
    processedRequests() {
      return this.timeOffRequests
        .filter(req => req.status !== 'pending')
        .sort((a, b) => new Date(b.updatedAt) - new Date(a.updatedAt));
    }
  },
  methods: {
    async fetchData() {
      this.loading = true;
      this.error = null;
      
      try {
        const [employeesRes, timeOffRes] = await Promise.all([
          axios.get('http://localhost:5000/employee'),
          axios.get('http://localhost:5000/timeOff')
        ]);
        
        this.employees = employeesRes.data;
        this.timeOffRequests = timeOffRes.data.map(request => {
          const employee = this.employees.find(e => e.id == request.employeeId);
          return {
            ...request,
            employeeName: employee ? employee.name : 'Unknown Employee'
          };
        });
      } catch (err) {
        this.error = 'Failed to load data. Please try again.';
        console.error('Error fetching data:', err);
      } finally {
        this.loading = false;
      }
    },
    async updateRequestStatus(requestId, status) {
      if (!confirm(`Are you sure you want to ${status} this leave request?`)) return;
      
      try {
        await axios.put(`http://localhost:5000/timeOff/${requestId}`, { 
          status: status 
        });
        await this.fetchData();
      } catch (err) {
        console.error('Error updating request:', err);
        alert('Failed to update request status. Please try again.');
      }
    },
    getRequestCount(employeeId, status) {
      return this.timeOffRequests
        .filter(req => req.employeeId == employeeId && req.status === status)
        .length;
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      const options = { year: 'numeric', month: 'short', day: 'numeric' };
      return new Date(dateString).toLocaleDateString(undefined, options);
    },
    calculateDays(startDate, endDate) {
      const start = new Date(startDate);
      const end = new Date(endDate);
      const diffTime = Math.abs(end - start);
      return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 to include both start and end days
    },
    showRequestDetails(request) {
      this.selectedRequest = request;
      if (!this.detailsModal) {
        this.detailsModal = new Modal(document.getElementById('requestDetailsModal'));
      }
      this.detailsModal.show();
    }
  },
  mounted() {
    this.fetchData();
  }
};
</script>

<style scoped>
.timeoff-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  flex-wrap: wrap;
  gap: 20px;
}

.header h1 {
  font-size: 1.8rem;
  font-weight: 600;
  margin: 0;
}

.search-container {
  flex-grow: 1;
  max-width: 400px;
}

.search-input {
  width: 100%;
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 20px;
}

.loading-state {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  gap: 15px;
  font-size: 1.1rem;
}

.error-state {
  margin: 20px 0;
}

.card {
  border: none;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.card-header {
  padding: 15px 20px;
  border-radius: 8px 8px 0 0 !important;
}

.card-header h2 {
  font-size: 1.3rem;
  margin: 0;
}

.table {
  margin-bottom: 0;
}

.table th {
  font-weight: 600;
  background-color: #f8f9fa;
}

.pending-column, .processed-column {
  padding: 0 15px;
}

.request-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.request-item {
  padding: 15px;
  border-radius: 8px;
  background-color: #fff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.request-approved {
  border-left: 4px solid #28a745;
}

.request-rejected {
  border-left: 4px solid #dc3545;
}

.request-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.employee-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.request-dates {
  font-size: 0.9rem;
  color: #6c757d;
}

.request-body {
  margin-bottom: 10px;
}

.process-date {
  color: #6c757d;
  font-size: 0.85rem;
  margin-top: 5px;
}

.request-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.btn-sm {
  padding: 5px 10px;
  font-size: 0.875rem;
}

.no-requests {
  padding: 20px;
  text-align: center;
  color: #6c757d;
  font-style: italic;
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-container {
    max-width: 100%;
  }
  
  .pending-column, .processed-column {
    padding: 0;
    margin-bottom: 20px;
  }
}
</style>