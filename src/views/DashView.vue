<template>
    <div class="payroll-view">
        <div class="header">
            <h1>Dashboard</h1>
            <div class="header-actions">
                <input type="text" placeholder="Search" v-model="searchQuery" @input="filterPayroll">
            </div>
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
            </div>
        </div>
    </div>
    <div class="line-chart-container animate__animated animate__fadeIn">
        <AttendanceLineChart :monthlyAttendance="monthlyAttendance" />
    </div>
    <div class="Cal animate__animated animate__fadeIn">
        <h3 class="cal-title">Calendar</h3>
        <hr>
        <div class="calendar-title">Employee Leave Calendar</div>
        <LeaveCalendar :leaveEvents="approvedLeaveEvents" />
    </div>
</template>

<script>
import AttendanceData from '@/assets/attendance.json'
import employeeInformation from '@/assets/employee_info.json'
import AttendanceLineChart from '@/components/AttendanceLineChart.vue'
import LeaveCalendar from '@/components/LeaveCalendar.vue'
import { mapGetters } from 'vuex';

export default {
    components: { AttendanceLineChart, LeaveCalendar },
    data() {
        return {
            attendanceData: AttendanceData,
            employeeInfo: employeeInformation,
            cardData: [
                { title: 'Total Employees', value: 'totalEmployees' },
                { title: 'Present', value: 'totalPresent' },
                { title: 'Absent', value: 'totalAbsent' },
                { title: 'Approved Leave', value: 'totalApproved' },
                { title: 'Denied Leave', value: 'totalDenied' }
            ]
        }
    },

    computed: {
        ...mapGetters(['getLeaveRequests', 'getEmployees']),
        totalEmployees() {
        
            return this.getEmployees.length ? this.getEmployees.length : this.attendanceData.attendanceAndLeave.length;
        },
        totalPresent() {
            const todayObj = new Date();
            const today =
                todayObj.getFullYear() + '-' +
                String(todayObj.getMonth() + 1).padStart(2, '0') + '-' +
                String(todayObj.getDate()).padStart(2, '0');
            return this.attendanceData.attendanceAndLeave.filter(emp =>
                emp.attendance.some(a => a.date === today && a.status === 'Present')
            ).length
        },
        totalAbsent() {
            const todayObj = new Date();
            const today =
                todayObj.getFullYear() + '-' +
                String(todayObj.getMonth() + 1).padStart(2, '0') + '-' +
                String(todayObj.getDate()).padStart(2, '0');
            return this.attendanceData.attendanceAndLeave.filter(emp =>
                emp.attendance.some(a => a.date === today && a.status === 'Absent')
            ).length
        },
        totalApproved() {
            return this.attendanceData.attendanceAndLeave.reduce((count, emp) => {
                return count + emp.leaveRequests.filter(req => req.status === 'Approved').length
            }, 0)
        },
        totalDenied() {
            return this.attendanceData.attendanceAndLeave.reduce((count, emp) => {
                return count + emp.leaveRequests.filter(req => req.status === 'Denied').length
            }, 0)
        },
        monthlyAttendance() {
            const months = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
            ]
            const presentCounts = Array(12).fill(0)
            const absentCounts = Array(12).fill(0)
            this.attendanceData.attendanceAndLeave.forEach(emp => {
                emp.attendance.forEach(a => {
                    const date = new Date(a.date)
                    if (!isNaN(date)) {
                        const monthIdx = date.getMonth()
                        if (a.status === 'Present') presentCounts[monthIdx] += 1
                        if (a.status === 'Absent') absentCounts[monthIdx] += 1
                    }
                })
            })
            return months.map((m, i) => ({
                month: m,
                present: presentCounts[i],
                absent: absentCounts[i]
            }))
        },
        approvedLeaveEvents() {
            // Collect all approved leave events for the current month from both attendanceData and Vuex store
            const events = [];
            // From static attendanceData
            this.attendanceData.attendanceAndLeave.forEach(emp => {
                if (emp.leaveRequests && emp.leaveRequests.length) {
                    emp.leaveRequests.forEach(req => {
                        if (req.status === 'Approved') {
                            const start = new Date(req.startDate);
                            const end = new Date(req.endDate);
                            for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
                                const dateStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
                                events.push({
                                    date: dateStr,
                                    name: emp.name,
                                    employeeId: emp.employeeId
                                });
                            }
                        }
                    });
                }
            });
            // From Vuex leaveRequests (form submissions)
            this.getLeaveRequests.forEach(req => {
                if (req.status === 'Approved') {
                    // Support both single-day and range (if available)
                    const start = req.startDate ? new Date(req.startDate) : new Date(req.date);
                    const end = req.date ? new Date(req.date) : start;
                    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
                        const dateStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
                        events.push({
                            date: dateStr,
                            name: req.employeeName,
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
