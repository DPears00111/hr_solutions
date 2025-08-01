<template>
  <div class="payroll-view">
    <div class="header">
      <h1>Leave Requests</h1>
      
    </div>
  </div>
  <div class="form-container">
    <h3 class="border border-dark-subtle mb-4 rounded bg-primary text-white">Leave Request Form</h3>
    <div class="form mb-4">
      <form @submit.prevent="submitLeaveRequest">
        <div class="row mb-3">
          <label for="employeeId" class="col-sm-2 col-form-label text-primary">Employee ID</label>
          <div class="col-sm-10">
            <input 
              type="text" 
              class="form-control" 
              id="employeeId" 
              v-model="leaveForm.employeeId" 
              required
              @change="fetchEmployeeDetails"
            >
          </div>
        </div>

        <div class="row mb-3">
          <label for="employeeName" class="col-sm-2 col-form-label text-primary">Employee Name</label>
          <div class="col-sm-10">
            <input 
              type="text" 
              class="form-control" 
              id="employeeName" 
              v-model="leaveForm.employeeName" 
              readonly
            >
          </div>
        </div>

        <div class="row mb-3">
          <label for="leaveType" class="col-sm-2 col-form-label text-primary">Leave Type</label>
          <div class="col-sm-10">
            <select class="form-select" id="leaveType" v-model="leaveForm.leaveType" required>
              <option value="" disabled selected>Select leave type</option>
              <option value="vacation">Vacation</option>
              <option value="sick">Sick Leave</option>
              <option value="personal">Personal</option>
              <option value="bereavement">Bereavement</option>
              <option value="other">Other</option>
            </select>
          </div>
        </div>

        <div class="row mb-3">
          <label for="startDate" class="col-sm-2 col-form-label text-primary">Start Date</label>
          <div class="col-sm-10">
            <input 
              type="date" 
              class="form-control" 
              id="startDate" 
              v-model="leaveForm.startDate" 
              required
              @change="updateEndDateIfEmpty"
            >
          </div>
        </div>

        <div class="row mb-3">
          <label for="endDate" class="col-sm-2 col-form-label text-primary">End Date</label>
          <div class="col-sm-10">
            <input 
              type="date" 
              class="form-control" 
              id="endDate" 
              v-model="leaveForm.endDate" 
              required
              :min="leaveForm.startDate"
            >
          </div>
        </div>

        <div class="row mb-3">
          <label for="reason" class="col-sm-2 col-form-label text-primary">Reason</label>
          <div class="col-sm-10">
            <textarea 
              class="form-control" 
              id="reason" 
              rows="3" 
              v-model="leaveForm.reason" 
              required
            ></textarea>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="emergency" 
                v-model="leaveForm.isEmergency"
              >
              <label class="form-check-label" for="emergency">
                Emergency Leave
              </label>
            </div>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col-sm-10 offset-sm-2">
            <button type="submit" class="btn btn-primary">Submit Request</button>
            <button type="reset" class="btn btn-secondary ms-2" @click="resetForm">Reset Form</button>
          </div>
        </div>
      </form>
    </div>

    <!-- Display the list of leave requests -->
    <div class="leave-requests mt-5" v-if="requests.length > 0">
      <h3 class="text-primary mb-4">My Leave Requests</h3>
      <ul class="list-group">
        <li 
          class="list-group-item d-flex justify-content-between align-items-center"
          v-for="(request, index) in filteredRequests" 
          :key="request.id"
        >
          <div>
            <strong>{{ request.employeeName }}</strong><br>
            {{ formatDate(request.startDate) }} to {{ formatDate(request.endDate) }}<br>
            <em>{{ request.reason }}</em>
            <span 
              class="badge ms-2"
              :class="{
                'bg-warning': request.status === 'pending',
                'bg-success': request.status === 'approved',
                'bg-danger': request.status === 'rejected'
              }"
            >
              {{ request.status }}
            </span>
          </div>
          <button 
            class="btn btn-sm btn-outline-danger" 
            @click="removeRequest(request.id)"
            v-if="request.status === 'pending'"
          >
            Cancel
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      searchQuery: '',
      leaveForm: {
        employeeId: '',
        employeeName: '',
        leaveType: '',
        startDate: '',
        endDate: '',
        reason: '',
        isEmergency: false
      },
      requests: [],
      employees: []
    };
  },
  computed: {
    filteredRequests() {
      if (!this.searchQuery) return this.requests;
      const query = this.searchQuery.toLowerCase();
      return this.requests.filter(request => 
        request.employeeName.toLowerCase().includes(query) ||
        request.reason.toLowerCase().includes(query) ||
        request.status.toLowerCase().includes(query)
      );
    }
  },
  methods: {
    async fetchEmployeeDetails() {
      if (!this.leaveForm.employeeId) return;
      
      try {
        const response = await axios.get(`http://localhost:5000/employee/${this.leaveForm.employeeId}`);
        this.leaveForm.employeeName = response.data.name;
      } catch (error) {
        console.error('Error fetching employee details:', error);
        this.leaveForm.employeeName = '';
        alert('Employee not found. Please check the ID.');
      }
    },
    async fetchRequests() {
      try {
        const response = await axios.get('http://localhost:5000/timeOff');
        this.requests = response.data.map(request => {
          const employee = this.employees.find(e => e.id == request.employeeId);
          return {
            ...request,
            employeeName: employee ? employee.name : 'Unknown'
          };
        });
      } catch (error) {
        console.error('Failed to fetch leave requests:', error);
        alert('Failed to load leave requests.');
      }
    },
    async fetchEmployees() {
      try {
        const response = await axios.get('http://localhost:5000/employee');
        this.employees = response.data;
      } catch (error) {
        console.error('Failed to fetch employees:', error);
      }
    },
    updateEndDateIfEmpty() {
      if (this.leaveForm.startDate && !this.leaveForm.endDate) {
        this.leaveForm.endDate = this.leaveForm.startDate;
      }
    },
    async submitLeaveRequest() {
      if (!this.leaveForm.employeeName) {
        alert('Please enter a valid employee ID');
        return;
      }

      const request = {
        employeeId: this.leaveForm.employeeId,
        startDate: this.leaveForm.startDate,
        endDate: this.leaveForm.endDate,
        reason: this.leaveForm.reason,
        leaveType: this.leaveForm.leaveType,
        isEmergency: this.leaveForm.isEmergency,
        status: 'pending'
      };

      try {
        await axios.post('http://localhost:5000/timeOff', request);
        alert('Leave request submitted successfully!');
        this.resetForm();
        await this.fetchRequests();
      } catch (error) {
        console.error('Error submitting leave request:', error);
        alert('Failed to submit leave request. Please try again.');
      }
    },
    async removeRequest(requestId) {
      if (!confirm('Are you sure you want to cancel this leave request?')) return;
      
      try {
        await axios.delete(`http://localhost:5000/timeOff/${requestId}`);
        await this.fetchRequests();
        alert('Leave request cancelled successfully.');
      } catch (error) {
        console.error('Error cancelling leave request:', error);
        alert('Failed to cancel leave request. Please try again.');
      }
    },
    resetForm() {
      this.leaveForm = {
        employeeId: '',
        employeeName: '',
        leaveType: '',
        startDate: '',
        endDate: '',
        reason: '',
        isEmergency: false
      };
    },
    formatDate(dateStr) {
      if (!dateStr) return '';
      const options = { year: 'numeric', month: 'short', day: 'numeric' };
      return new Date(dateStr).toLocaleDateString(undefined, options);
    }
  },
  async mounted() {
    await this.fetchEmployees();
    await this.fetchRequests();
  }
};
</script>

<style scoped>
.payroll-view {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  font-weight: bold;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

input[type="text"] {
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 20px;
  min-width: 250px;
}

.form-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.leave-requests {
  border-top: 1px solid #eee;
  padding-top: 20px;
}

.list-group-item {
  margin-bottom: 10px;
}
</style>