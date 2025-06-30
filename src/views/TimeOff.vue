<template>
  <div class="payroll-view">
        <div class="header">
            <h1>Time-Off</h1>
            <div class="header-actions">
                <input type="text" placeholder="Search" v-model="searchQuery" @input="filterPayroll">
            </div>
        </div>
  </div>
  <div class="attendance-dashboard">
    <!-- Employee Attendance Summary -->
    <div class="card mb-4">
      <div class="card-header bg-primary text-white">
        <h3>Employee Attendance</h3>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr class="table-info">
                <th>Employee</th>
                <th>Present Days</th>
                <th>Absent Days</th>
                <th>Pending Leave</th>
                <th>Approved Leave</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="emp in attendanceData.attendanceAndLeave" :key="emp.employeeId">
                <td>{{ emp.name }}</td>
                <td>{{ countStatus(emp.attendance, 'Present') }}</td>
                <td>{{ countStatus(emp.attendance, 'Absent') }}</td>
                <td>{{ countLeaveStatus(emp.leaveRequests, 'Pending') }}</td>
                <td>{{ countLeaveStatus(emp.leaveRequests, 'Approved') }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Leave Request Management -->
    <div class="card">
      <div class="card-header bg-info text-white">
        <h3>Leave Requests</h3>
      </div>
      <div class="card-body">
        <div class="row">
          <!-- Pending Requests -->
          <div class="col-md-6">
            <h4>Pending Approval</h4>
            <ul class="list-group">
              <!-- JSON-requests -->
              <li v-for="req in getPendingJSONRequests()" :key="'json-'+req.employeeId+req.date" class="list-group-item">
                <strong>{{ getEmployeeName(req.employeeId) }}</strong><br>
                {{ req.date }} - {{ req.reason }}
                <div class="mt-2">
                  <button class="btn btn-sm btn-success me-2" @click="approveRequest(req)">Approve</button>
                  <button class="btn btn-sm btn-danger" @click="denyRequest(req)">Deny</button>
                </div>
              </li>
              
              <!-- Local-requests -->
              <li v-for="req in pendingLeaveRequests" :key="'vuex-'+req.id" class="list-group-item">
                <strong>{{ req.employeeName }}</strong><br>
                {{ formatDate(req.date) }} - {{ req.leaveType }}
                <span v-if="req.isEmergency" class="badge bg-danger ms-2">Emergency</span>
                <div class="mt-2">
                  <button class="btn btn-sm btn-success me-2" @click="approveVuexRequest(req)">Approve</button>
                  <button class="btn btn-sm btn-danger" @click="denyVuexRequest(req)">Deny</button>
                </div>
              </li>
            </ul>
          </div>

          <!-- Processed Requests -->
          <div class="col-md-6">
            <h4>Recently Processed</h4>
            <ul class="list-group">
              <!-- JSON-sourced requests -->
              <li v-for="req in getProcessedJSONRequests()" 
                  :key="'json-'+req.employeeId+req.date"
                  class="list-group-item"
                  :class="{
                    'list-group-item-success': req.status === 'Approved',
                    'list-group-item-danger': req.status === 'Denied'
                  }">
                <strong>{{ getEmployeeName(req.employeeId) }}</strong><br>
                {{ req.date }} - {{ req.reason }}<br>
                <small class="text-muted">Status: {{ req.status }}</small>
              </li>
              
              <!-- Vuex-sourced requests -->
              <li v-for="req in processedLeaveRequests" 
                  :key="'vuex-'+req.id"
                  class="list-group-item"
                  :class="{
                    'list-group-item-success': req.status === 'Approved',
                    'list-group-item-danger': req.status === 'Denied'
                  }">
                <strong>{{ req.employeeName }}</strong><br>
                {{ formatDate(req.date) }} - {{ req.leaveType }}<br>
                <small class="text-muted">Status: {{ req.status }}</small>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import attendanceData from '@/assets/attendance.json';
import { mapGetters, mapActions } from 'vuex';

export default {
  data() {
    return {
      attendanceData: JSON.parse(JSON.stringify(attendanceData)),
      leaveForm: {
        employeeName: '',
        employeeId: '',
        leaveType: '',
        startDate: '',
        endDate: '',
        reason: '',
        isEmergency: false
      }
    };
  },
  computed: {
    ...mapGetters(['getLeaveRequests']),
    pendingLeaveRequests() {
      return this.getLeaveRequests.filter(req => req.status === 'Pending');
    },
    processedLeaveRequests() {
      return this.getLeaveRequests
        .filter(req => req.status !== 'Pending')
        .sort((a, b) => new Date(b.date) - new Date(a.date));
    }
  },
  methods: {
    ...mapActions(['loadLeaveRequests']),
    
    // JSON data methods
    getPendingJSONRequests() {
      return this.attendanceData.attendanceAndLeave
        .flatMap(emp => 
          emp.leaveRequests
            .filter(req => req.status === 'Pending')
            .map(req => ({ ...req, employeeId: emp.employeeId }))
        );
    },
    getProcessedJSONRequests() {
      return this.attendanceData.attendanceAndLeave
        .flatMap(emp => 
          emp.leaveRequests
            .filter(req => req.status !== 'Pending')
            .map(req => ({ ...req, employeeId: emp.employeeId }))
        )
        .sort((a, b) => new Date(b.date) - new Date(a.date));
    },
    approveRequest(request) {
      this.updateJsonRequestStatus(request, 'Approved');
    },
    denyRequest(request) {
      this.updateJsonRequestStatus(request, 'Denied');
    },
    updateJsonRequestStatus(request, newStatus) {
      let employee = this.attendanceData.attendanceAndLeave.find(
        emp => emp.employeeId === request.employeeId
      );
      if (employee) {
        const leaveRequest = employee.leaveRequests.find(
          req => req.date === request.date && req.reason === request.reason
        );
        if (leaveRequest) {
          leaveRequest.status = newStatus;
          this.attendanceData.attendanceAndLeave = [
            ...this.attendanceData.attendanceAndLeave
          ];
        }
      }
    },
    
    // Vuex store methods
    approveVuexRequest(request) {
      this.$store.commit('updateLeaveRequestStatus', {
        id: request.id,
        status: 'Approved'
      });
    },
    denyVuexRequest(request) {
      this.$store.commit('updateLeaveRequestStatus', {
        id: request.id,
        status: 'Denied'
      });
    },
    
    // Shared methods
    countStatus(records, status) {
      return records.filter(r => r.status === status).length;
    },
    countLeaveStatus(records, status) {
      return records.filter(r => r.status === status).length;
    },
    getEmployeeName(id) {
      const emp = this.attendanceData.attendanceAndLeave.find(e => e.employeeId === id);
      return emp ? emp.name : 'Unknown';
    },
    formatDate(dateStr) {
      if (!dateStr) return '';
      const d = new Date(dateStr);
      return d.toLocaleDateString();
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
.list-group-item {
  margin-bottom: 10px;
  border-radius: 5px;
}

.card {
  margin-bottom: 20px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.timeoff-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}
</style>