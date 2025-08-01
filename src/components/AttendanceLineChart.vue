<template>
  <div>
    <canvas ref="lineChart"></canvas>
  </div>
</template>

<script>
import { Chart, LineController, LineElement, PointElement, LinearScale, Title, CategoryScale, Tooltip, Legend } from 'chart.js'

Chart.register(LineController, LineElement, PointElement, LinearScale, Title, CategoryScale, Tooltip, Legend)

export default {
  props: {
    weeklyAttendance: {
      type: Array,
      required: true
    }
  },
  mounted() {
    this.renderChart();
  },
  watch: {
    weeklyAttendance: {
      handler() {
        this.renderChart();
      },
      deep: true
    }
  },
  methods: {
    renderChart() {
      if (this.chartInstance) {
        this.chartInstance.destroy();
      }
      
      const ctx = this.$refs.lineChart.getContext('2d');
      this.chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
          labels: this.weeklyAttendance.map(item => item.week),
          datasets: [
            {
              label: 'Present',
              data: this.weeklyAttendance.map(item => item.present),
              borderColor: '#599bca',
              backgroundColor: 'rgba(89,155,202,0.2)',
              fill: false,
              tension: 0.3
            },
            {
              label: 'Absent',
              data: this.weeklyAttendance.map(item => item.absent),
              borderColor: '#eb3b5a',
              backgroundColor: 'rgba(235,59,90,0.2)',
              fill: false,
              tension: 0.3
            }
          ]
        },
        options: {
          responsive: true,
          plugins: {
            legend: { display: true, position: 'bottom' },
            title: {
              display: true,
              text: 'Weekly Attendance Overview'
            }
          },
          scales: {
            y: { 
              beginAtZero: true,
              title: {
                display: true,
                text: 'Number of Employees'
              }
            },
            x: {
              title: {
                display: true,
                text: 'Week Number'
              }
            }
          }
        }
      });
    }
  },
  beforeDestroy() {
    if (this.chartInstance) {
      this.chartInstance.destroy();
    }
  }
}
</script>