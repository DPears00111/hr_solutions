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
    monthlyAttendance: {
      type: Array,
      required: true
    }
  },
  mounted() {
    const ctx = this.$refs.lineChart.getContext('2d')
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.monthlyAttendance.map(item => item.month),
        datasets: [
          {
            label: 'Present',
            data: this.monthlyAttendance.map(item => item.present),
            borderColor: '#599bca',
            backgroundColor: 'rgba(89,155,202,0.2)',
            fill: false,
            tension: 0.3
          },
          {
            label: 'Absent',
            data: this.monthlyAttendance.map(item => item.absent),
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
          legend: { display: true, position: 'bottom' }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    })
  }
}
</script>