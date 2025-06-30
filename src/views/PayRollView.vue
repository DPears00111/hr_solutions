<template>
    <div class="payroll-view">
        <div class="header">
            <h1>PAYROLL</h1>
            <div class="header-actions">
                <input type="text" placeholder="Search" v-model="searchQuery" @input="filterPayroll">
            </div>
        </div>

        <div class="table-section animate__animated animate__fadeInUp">
            <h2>Employee Payroll</h2>
            <table class="table animate__animated animate__fadeInUp" ref="payrollTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Employee Name</th>
                        <th>Position</th>
                        <th>Department</th>
                        <th>Salary</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(employee, index) in filteredEmployees" :key="employee.employeeId" class="animate__animated animate__fadeInUp">
                        <td>{{ index + 1 }}</td>
                        <td>{{ employee.name }}</td>
                        <td>{{ employee.position }}</td>
                        <td>{{ employee.department }}</td>
                        <td>R{{ employee.salary.toFixed(2) }}</td>
                        <td>
                            <button @click="viewPayslip(employee)" class="action-btn">View Payslip</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <PayrollSlip v-if="selectedEmployee" ref="payrollSlip" :employees="[selectedEmployee]"
            :period="currentPeriod" />
    </div>
</template>

<script>
import PayrollSlip from '@/components/PayrollSlip.vue'
import employeeData from '@/assets/employee_info.json'

export default {
    components: {
        PayrollSlip
    },
    data() {
        return {
            employees: employeeData.employeeInformation,
            searchQuery: '',
            selectedEmployee: null,
            currentPeriod: ''
        }
    },
    created() {
        this.currentPeriod = this.getCurrentPeriod()
    },
    computed: {
        filteredEmployees() {
            if (!this.searchQuery) return this.employees
            const query = this.searchQuery.toLowerCase()
            return this.employees.filter(emp =>
                emp.name.toLowerCase().includes(query) ||
                emp.employeeId.toString().includes(query) ||
                emp.department.toLowerCase().includes(query)
            )
        }
    },
    methods: {
        getCurrentPeriod() {
            const now = new Date()
            return `${now.toLocaleString('default', { month: 'long' })} ${now.getFullYear()}`
        },
        viewPayslip(employee) {
            this.selectedEmployee = employee
            // Scroll to payslip section
            this.$nextTick(() => {
                document.querySelector('.payslip-container')?.scrollIntoView({ behavior: 'smooth' })
            })
        },
        filterPayroll() {
            // Handled by computed property
        }
    }
}
</script>

<style scoped>
.payroll-view {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}
h1{
    font-weight: bold;
}
.table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
}

.table th,
.table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

.table th {
    background-color: #599bca;
    color: white;
}

.action-btn {
    background-color: #599bca;
    color: white;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    cursor: pointer;
}

.action-btn:hover {
    background-color: #4a8ab8;
}

input[type="text"] {
    padding: 8px 15px;
    border: 1px solid #ddd;
    border-radius: 20px;
    min-width: 250px;
}
.card-row {
    display: flex;
    gap: 24px;
    flex-wrap: wrap;
    justify-content: center;
}

.card {
    width: 250px;
    min-width: 180px;
    height: 150px;
    margin-bottom: 16px;
}
@media (max-width: 900px) {
    .card-row {
        flex-direction: column;
        align-items: center;
    }
    .card {
        width: 90vw;
        max-width: 350px;
    }
}

@media (max-width: 600px) {
    .header {
        flex-direction: column;
        gap: 12px;
    }
    .card {
        width: 98vw;
        max-width: 98vw;
        min-width: 0;
    }
    h1, h2 {
        font-size: 1.2rem;
    }
}
.table-section {
    width: 100%;
    overflow-x: auto;
}

.table {
    min-width: 600px; /* Ensures table doesn't shrink too much */
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
}

@media (max-width: 600px) {
    .table-section {
        overflow-x: auto;
    }
    .table {
        font-size: 0.9rem;
        min-width: 500px;
    }
    .table th, .table td {
        padding: 8px;
    }
}
</style>