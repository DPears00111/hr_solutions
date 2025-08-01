<template>
    <div class="payroll-view">
        <div class="header">
            <h1>Dashboard</h1>

        </div>
    </div>
    <div>
        <h2>OVERVIEW</h2>
        <hr>
    </div>

    <div class="overview animate__animated animate__fadeInUp">
        <div class="card-row">
            <div class="card animate__animated animate__fadeInUp" v-for="(card, idx) in cardData" :key="idx">
                <h3>{{ card.title }}</h3>
                <hr>
                <div class="card-bottom">
                    <h4>{{ this[card.value] }}</h4>
                </div>
                <div v-if="card.value === 'totalEmployees' && employeeInfo.length" class="employee-list">
                    <ul>
                        <li v-for="emp in employeeInfo" :key="emp.employeeId || emp.id">
                            {{ emp.name }}<span v-if="emp.position"> - {{ emp.position }}</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="line-chart-container animate__animated animate__fadeIn">
        <AttendanceLineChart :weeklyAttendance="weeklyAttendance" />
    </div>
    <div class="Cal animate__animated animate__fadeIn">
        <h3 class="cal-title">Calendar</h3>
        <hr>
        <div class="calendar-title">Employee Leave Calendar</div>
        <LeaveCalendar :leaveEvents="approvedLeaveEvents" />
    </div>
</template>

<script>
import axios from 'axios';
import AttendanceLineChart from '@/components/AttendanceLineChart.vue'
import LeaveCalendar from '@/components/LeaveCalendar.vue'
import { mapGetters } from 'vuex';

export default {
    components: { AttendanceLineChart, LeaveCalendar },
    data() {
        return {
            searchQuery: '',
            attendanceData: [],
            employeeInfo: [],
            cardData: [
                { title: 'Total Employees', value: 'totalEmployees' },
                { title: 'Present', value: 'totalPresent' },
                { title: 'Absent', value: 'totalAbsent' },
                { title: 'Approved Leave', value: 'totalApproved' },
                { title: 'Denied Leave', value: 'totalDenied' }
            ],
            leaveRequests: []
        }
    },

    async mounted() {
        await this.fetchAttendanceData();
        await this.fetchEmployeeInfo();
        await this.fetchLeaveRequests();
    },

    methods: {
        getWeekNumber(date) {
            const d = new Date(date);
            d.setHours(0, 0, 0, 0);
            d.setDate(d.getDate() + 3 - (d.getDay() + 6) % 7);
            const week1 = new Date(d.getFullYear(), 0, 4);
            return 1 + Math.round(((d - week1) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);
        },
        async fetchAttendanceData() {
            try {
                const response = await axios.get('http://localhost:5000/attendance');
                this.attendanceData = response.data;
            } catch (error) {
                console.error('Failed to fetch attendance data:', error);
            }
        },
        async fetchEmployeeInfo() {
            try {
                const response = await axios.get('http://localhost:5000/employee');
                this.employeeInfo = response.data;
            } catch (error) {
                console.error('Failed to fetch employee info:', error);
            }
        },
        async fetchLeaveRequests() {
            try {
                const response = await axios.get('http://localhost:5000/timeOff');
                this.leaveRequests = response.data;
            } catch (error) {
                console.error('Failed to fetch leave requests:', error);
            }
        },
    },

    computed: {
        ...mapGetters(['getLeaveRequests', 'getEmployees']),
        totalEmployees() {
            return this.employeeInfo.length || 0;
        },
        totalPresent() {
            return this.attendanceData.filter(a => a.status === 'Present').length;
        },
        totalAbsent() {
            return this.attendanceData.filter(a => a.status === 'Absent').length;
        },
        totalApproved() {
            return this.leaveRequests.filter(req => (req.status || '').toLowerCase() === 'approved').length;
        },
        totalDenied() {
            return this.leaveRequests.filter(req => (req.status || '').toLowerCase() === 'rejected').length;
        },
        weeklyAttendance() {
            const weeks = [];
            const currentDate = new Date();
            const currentWeek = this.getWeekNumber(currentDate);
            
            for (let i = 3; i >= 0; i--) {
                const weekNum = currentWeek - i;
                weeks.push({
                    week: `Week ${weekNum}`,
                    present: 0,
                    absent: 0
                });
            }

            this.attendanceData.forEach(record => {
                const date = new Date(record.date);
                const weekNum = this.getWeekNumber(date);
                const weekIndex = currentWeek - weekNum;
                
                if (weekIndex >= 0 && weekIndex < 4) {
                    if (record.status === 'Present') {
                        weeks[3 - weekIndex].present++;
                    } else if (record.status === 'Absent') {
                        weeks[3 - weekIndex].absent++;
                    }
                }
            });

            return weeks;
        },
        approvedLeaveEvents() {
            const events = [];
            
            this.leaveRequests.forEach(req => {
                if (req.status === 'approved') {
                    const employee = this.employeeInfo.find(e => e.id === req.employeeId);
                    const start = new Date(req.startDate);
                    const end = new Date(req.endDate);
                    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
                        const dateStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
                        events.push({
                            date: dateStr,
                            name: employee ? employee.name : 'Unknown',
                            employeeId: req.employeeId
                        });
                    }
                }
            });

            return events;
        },
    }
}
</script>

<style scoped>
.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24px;
}

h1 {
    font-weight: bold;
}

input[type="text"] {
    padding: 8px 15px;
    border: 1px solid #ddd;
    border-radius: 20px;
    min-width: 250px;
}

h2 {
    display: flex;
    justify-content: center;
}

.overview {
    display: flex;
    flex-direction: column;
    padding: 15px;
    gap: 24px;
}

.card-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 24px;
    width: 100%;
}

.card {
    display: flex;
    flex-direction: column;
    align-content: center;
    min-width: 0;
    max-width: 100%;
    height: 150px;
    border: none;
    background-color: rgb(255, 255, 255);
    box-shadow: rgba(0, 0, 0, 0.4) 0px 30px 90px;
    position: relative;
    overflow: hidden;
    margin-bottom: 0;
}

.card-bottom {
    background-color: #599bca;
    height: 50%;
    width: 100%;
    position: absolute;
    bottom: 0;
    left: 0;
    z-index: 1;
    display: flex;
    align-items: flex-end;
    justify-content: center;
    padding-bottom: 16px;
}

.card-bottom i {
    font-size: 2.5rem;
    color: #fff;
}

.card h3 {
    position: relative;
    z-index: 2;
    margin: 24px auto 0 auto;
}

.card hr {
    width: 60%;
    margin: 8px auto;
    border: none;
    border-top: 2px solid #000000;
}

.Cal {
    margin-top: 32px;
    width: 100%;
    max-width: 100%;
    height: auto;
    background: #fff;
    box-shadow: rgba(0, 0, 0, 0.4) 0px 30px 90px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    border-radius: 15px;
    padding-top: 24px;
    box-sizing: border-box;
}

.cal-title {
    margin: 0;
    font-size: 2rem;
    font-weight: bold;
}

.Cal hr {
    width: 60%;
    margin: 8px auto;
    border-top: 2px solid #000000;
}

.calendar-title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 8px;
}

.Cal iframe {
    width: 100% !important;
    max-width: 100%;
    height: 400px;
    min-height: 300px;
}

.line-chart-container {
    width: 100%;
    max-width: 900px;
    margin: 32px auto;
}

.line-chart-container canvas {
    width: 100% !important;
    height: 350px !important;
}

@media (max-width: 900px) {
    .Cal {
        width: 100%;
        min-width: 0;
        max-width: 100vw;
        height: auto;
    }
    .card-row {
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    }
}

@media (max-width: 600px) {
    .header {
        flex-direction: column;
        gap: 12px;
    }
    .Cal {
        width: 100vw;
        padding: 0;
    }
    .card-row {
        grid-template-columns: 1fr;
    }
    h1, h2 {
        font-size: 1.2rem;
    }
}
</style>