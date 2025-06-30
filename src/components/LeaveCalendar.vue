<template>
  <div class="leave-calendar">
    <table class="calendar-table">
      <thead>
        <tr>
          <th v-for="day in days" :key="day">{{ day }}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(week, wIdx) in calendar" :key="wIdx">
          <td v-for="dateObj in week" :key="dateObj.date" :class="[{ today: dateObj.isToday }, { 'leave-day': dateObj.leaves.length > 0 }]">
            <div class="date-label">{{ dateObj.day }}</div>
            <div v-if="dateObj.leaves.length" class="leave-list">
              <div v-for="leave in dateObj.leaves" :key="leave.employeeId" class="leave-entry">
                <span class="leave-name">{{ leave.name }}</span>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'LeaveCalendar',
  props: {
    leaveEvents: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      days: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    }
  },
  computed: {
    calendar() {
      // Get current month and year
      const now = new Date();
      const year = now.getFullYear();
      const month = now.getMonth();
      // First day of month
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      const numDays = lastDay.getDate();
      const startDay = firstDay.getDay();
      // Build calendar grid
      const weeks = [];
      let week = [];
      let dayNum = 1 - startDay;
      while (dayNum <= numDays) {
        week = [];
        for (let i = 0; i < 7; i++, dayNum++) {
          const date = new Date(year, month, dayNum);
          const isThisMonth = date.getMonth() === month && dayNum > 0 && dayNum <= numDays;
          const isToday = isThisMonth && date.toDateString() === new Date().toDateString();
          const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
          const leaves = isThisMonth
            ? this.leaveEvents.filter(ev => ev.date === dateStr)
            : [];
          week.push({
            day: isThisMonth ? date.getDate() : '',
            date: dateStr,
            isToday,
            leaves
          });
        }
        weeks.push(week);
      }
      return weeks;
    }
  }
}
</script>

<style scoped>
.leave-calendar {
  width: 100%;
  overflow-x: auto;
}
.calendar-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 0 10px #ccc;
}
.calendar-table th, .calendar-table td {
  border: 1px solid #e0e0e0;
  width: 14.2%;
  min-width: 90px;
  height: 80px;
  vertical-align: top;
  padding: 4px;
  text-align: left;
}
.date-label {
  font-weight: bold;
  margin-bottom: 2px;
}
.today {
  background: #e3f2fd;
}
.leave-day {
  background: #ffe082 !important; /* Light yellow highlight for leave days */
  border: 2px solid #fbc02d;
}
.leave-list {
  margin-top: 4px;
}
.leave-entry {
  background: #599bca;
  color: #fff;
  border-radius: 6px;
  padding: 2px 6px;
  margin-bottom: 2px;
  font-size: 0.9em;
}
</style>
