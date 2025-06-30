<template>
  <div class="payroll-view">
        <div class="header">
            <h1>Leave Requests</h1>
            <div class="header-actions">
                <input type="text" placeholder="Search" v-model="searchQuery" @input="filterPayroll">
            </div>
        </div>
  </div>
  <div class="form-container">
    <h3 class="border border-dark-subtle mb-4 rounded bg-primary text-white">Leave Requests</h3>
    <div class="form mb-4">
      <form @submit.prevent="submitLeaveRequest">
        <div class="row mb-3">
          <label for="employeeName" class="col-sm-2 col-form-label text-primary">Employee Name</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="employeeName" v-model="leaveForm.employeeName" required>
          </div>
        </div>

        <div class="row mb-3">
          <label for="employeeId" class="col-sm-2 col-form-label text-primary">Employee ID</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="employeeId" v-model="leaveForm.employeeId" required>
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
          <label for="date" class="col-sm-2 col-form-label text-primary">Date</label>
          <div class="col-sm-10">
            <input type="date" class="form-control" id="date" v-model="leaveForm.date" required>
          </div>
        </div>



        <div class="row mb-3">
          <label for="reason" class="col-sm-2 col-form-label text-primary">Reason</label>
          <div class="col-sm-10">
            <textarea class="form-control" id="reason" rows="3" v-model="leaveForm.reason" required></textarea>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="emergency" v-model="leaveForm.isEmergency">
              <label class="form-check-label" for="emergency">
                Emergency Leave
              </label>
            </div>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col-sm-10 offset-sm-2">
            <button type="submit" class="btn btn-primary">Submit Request</button>
            <button type="reset" class="btn btn-secondary ms-2">Reset Form</button>
          </div>
        </div>
      </form>
    </div>

    <!-- Display the list of leave requests -->
    <div class="leave-requests mt-5" v-if="leaveRequests.length > 0">
      <h3 class="text-primary mb-4">Leave Requests</h3>
      <ul class="list-group">
        <li class="list-group-item d-flex justify-content-between align-items-center"
          v-for="(request, index) in leaveRequests" :key="index">
          <div>
            <strong>{{ request.employeeName }} (ID: {{ request.employeeId }})</strong><br>
            <span class="text-muted">{{ request.leaveType }} Leave</span> |
            {{ formatDate(request.startDate) }} to {{ formatDate(request.date) }}<br>
            <em>{{ request.reason }}</em>
            <span v-if="request.isEmergency" class="badge bg-danger ms-2">Emergency</span>
          </div>
          <button class="btn btn-sm btn-outline-danger" @click="removeRequest(index)">
            Remove
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';

export default {
  data() {
    return {
      leaveForm: {
        employeeName: '',
        employeeId: '',
        leaveType: '',
        date: '',
        reason: '',
        isEmergency: false
      }
    };
  },
  computed: {
    ...mapGetters(['getLeaveRequests']),
    leaveRequests() {
      return this.getLeaveRequests;
    }
  },
  methods: {
    ...mapActions(['addLeaveRequest', 'loadLeaveRequests']),
    submitLeaveRequest() {
      const newRequest = {
        ...this.leaveForm,
        id: Date.now(),
        status: 'Pending'
      };
      this.addLeaveRequest(newRequest);
      this.resetForm();
    },
    resetForm() {
      this.leaveForm = {
        employeeName: '',
        employeeId: '',
        leaveType: '',
        date: '',
        reason: '',
        isEmergency: false
      };
    },
    formatDate(dateStr) {
      if (!dateStr) return '';
      const d = new Date(dateStr);
      return d.toLocaleDateString();
    },
    removeRequest(index) {
      this.$store.state.leaveRequests.splice(index, 1);
      localStorage.setItem('leaveRequests', JSON.stringify(this.$store.state.leaveRequests));
    }
  },
  mounted() {
    this.loadLeaveRequests();
  }
};
</script>

<style scoped>
.payroll-view {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}
h1{
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